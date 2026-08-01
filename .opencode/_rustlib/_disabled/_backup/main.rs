//! assembler-core binary — CLI endpoint for TypeScript imperative shell
//! TypeScript tools call this binary for pure functional operations.
//! All I/O is handled by the caller (TypeScript); this binary processes data.
//!
//! Usage:
//!   assemble parse [--text <yaml>]
//!   assemble id-to-type <id>
//!   assemble type-to-ring <type>
//!   assemble rrf --vector <json> --keyword <json> [--limit <n>]
//!   assemble types

use std::io::Read;

fn cmd_parse(args: &[String]) -> Result<String, String> {
    let text = if args.is_empty() {
        // Read from stdin
        let mut buf = String::new();
        std::io::stdin().read_to_string(&mut buf).map_err(|e| format!("stdin read error: {}", e))?;
        buf
    } else if args.len() >= 2 && args[0] == "--text" {
        args[1].clone()
    } else {
        return Err("usage: assemble parse [--text <yaml>] (or pipe to stdin)".to_string());
    };

    match assembler_core::parse::parse_frontmatter(&text) {
        Some(fm) => serde_json::to_string_pretty(&fm).map_err(|e| format!("json error: {}", e)),
        None => {
            // Try backmatter
            match assembler_core::parse::parse_backmatter(&text) {
                Some(bm) => serde_json::to_string_pretty(&bm).map_err(|e| format!("json error: {}", e)),
                None => {
                    // Try raw YAML
                    match assembler_core::parse::parse_frontmatter_raw(&text) {
                        Some(raw) => serde_json::to_string_pretty(&raw).map_err(|e| format!("json error: {}", e)),
                        None => Err("no frontmatter or backmatter found".to_string()),
                    }
                }
            }
        }
    }
}

fn cmd_id_to_type(args: &[String]) -> Result<String, String> {
    let id = args.first().ok_or("usage: assemble id-to-type <id>")?;
    match assembler_core::id_routing::id_to_type(id) {
        Some(t) => Ok(serde_json::json!({ "id": id, "type": t }).to_string()),
        None => Err(format!("unknown entity prefix in '{}'", id)),
    }
}

fn cmd_type_to_ring(args: &[String]) -> Result<String, String> {
    let type_name = args.first().ok_or("usage: assemble type-to-ring <type>")?;
    match assembler_core::ring_topology::type_to_ring(type_name) {
        Some((group, ring)) => Ok(serde_json::json!({ "type": type_name, "group": group, "ring": ring }).to_string()),
        None => Err(format!("unknown entity type '{}'", type_name)),
    }
}

fn cmd_rrf(args: &[String]) -> Result<String, String> {
    let vec_idx = args.iter().position(|a| a == "--vector").and_then(|i| args.get(i + 1));
    let kw_idx = args.iter().position(|a| a == "--keyword").and_then(|i| args.get(i + 1));
    let limit = args.iter().position(|a| a == "--limit")
        .and_then(|i| args.get(i + 1))
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(10);

    let vector_json = vec_idx.ok_or("usage: assemble rrf --vector <json> --keyword <json> [--limit <n>]")?;
    let keyword_json = kw_idx.ok_or("missing --keyword")?;

    let vector_hits: Vec<assembler_core::rank::RankedHit> = serde_json::from_str(vector_json)
        .map_err(|e| format!("vector hits parse error: {}", e))?;
    let keyword_hits: Vec<assembler_core::rank::RankedHit> = serde_json::from_str(keyword_json)
        .map_err(|e| format!("keyword hits parse error: {}", e))?;

    let results = assembler_core::rank::rrf(&vector_hits, &keyword_hits, limit);
    serde_json::to_string_pretty(&results).map_err(|e| format!("json error: {}", e))
}

fn cmd_types() -> Result<String, String> {
    let types: Vec<&str> = assembler_core::type_constants::ENTITY_TYPES.to_vec();
    Ok(serde_json::json!({ "types": types, "count": types.len() }).to_string())
}

fn cmd_validate(args: &[String]) -> Result<String, String> {
    let text = if args.is_empty() {
        let mut buf = String::new();
        std::io::stdin().read_to_string(&mut buf).map_err(|e| format!("stdin error: {}", e))?;
        buf
    } else if args.len() >= 2 && args[0] == "--text" {
        args[1].clone()
    } else {
        return Err("usage: assemble validate [--text <yaml>]".to_string());
    };

    match assembler_core::parse::parse_frontmatter(&text) {
        Some(fm) => {
            let violations: Vec<serde_json::Value> = assembler_core::validate::validate_frontmatter(&fm)
                .into_iter().map(|v| {
                    let field = v.split(':').next().unwrap_or("unknown");
                    serde_json::json!({ "field": field, "error": v })
                }).collect();
            Ok(serde_json::json!({ "valid": violations.is_empty(), "violations": violations }).to_string())
        }
        None => Err("no frontmatter found".to_string()),
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("assembler-core — functional core CLI");
        eprintln!();
        eprintln!("Commands:");
        eprintln!("  assemble parse [--text <yaml>]       Parse frontmatter from YAML text or stdin");
        eprintln!("  assemble id-to-type <id>              Look up entity type from patlib ID");
        eprintln!("  assemble type-to-ring <type>          Look up ring info from entity type name");
        eprintln!("  assemble rrf --vector <json> --keyword <json> [--limit <n>]  RRF merge");
        eprintln!("  assemble types                        List all entity types");
        eprintln!("  assemble validate [--text <yaml>]     Validate frontmatter fields");
        std::process::exit(1);
    }

    let cmd = &args[1];
    let cmd_args: Vec<String> = args[2..].to_vec();

    let result = match cmd.as_str() {
        "parse" => cmd_parse(&cmd_args),
        "id-to-type" => cmd_id_to_type(&cmd_args),
        "type-to-ring" => cmd_type_to_ring(&cmd_args),
        "rrf" => cmd_rrf(&cmd_args),
        "types" => cmd_types(),
        "validate" => cmd_validate(&cmd_args),
        _ => Err(format!("unknown command '{}'. Try: parse, id-to-type, type-to-ring, rrf, types, validate", cmd)),
    };

    match result {
        Ok(output) => println!("{}", output),
        Err(e) => {
            eprintln!("Error: {}", e);
            std::process::exit(1);
        }
    }
}
