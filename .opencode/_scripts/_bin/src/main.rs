#![allow(non_snake_case)]
//! assembler-cli — CLI entry point for entity auditing
//! ring: 6 (DB-WRITE) — orchestrates library modules, writes to report/

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "as", version, about = "Entity audit and survey toolchain")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// List entity types or entities of a type
    List { entity_type: Option<String> },
    /// Count entities per type
    Count,
    /// Run an entity integrity check
    Check {
        #[command(subcommand)]
        check: CheckCommand,
    },
    /// Run a structural audit scoped to one entity type
    Audit { entity_type: String },
    /// Show ring topology
    Rings,
}

#[derive(Subcommand)]
enum CheckCommand {
    /// Validate frontmatter id matches filename
    IdMatch,
    /// Validate ID prefix matches directory type
    RingMatch,
    /// Validate source field resolves to existing entity
    Source,
    /// Validate precedes targets exist with no cycles
    Precedes,
    /// Detect stale cross-references to non-existent entities
    StaleRefs,
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Command::List { entity_type } => cmd_list(entity_type),
        Command::Count => cmd_count(),
        Command::Check { check } => cmd_check(check),
        Command::Audit { entity_type } => cmd_audit(&entity_type),
        Command::Rings => cmd_rings(),
    }
}

fn cmd_list(entity_type: Option<String>) -> anyhow::Result<()> {
    match entity_type {
        Some(entity_type) => {
            let entries = assembler_scripts::r2_entity::loadEntities(&entity_type);
            println!("{} entities of type '{}':", entries.len(), entity_type);
            for entry in &entries {
                println!("  {} — {}", entry.id, entry.title);
            }
        }
        None => {
            let types = assembler_scripts::r2_paths::entityTypes();
            println!("Entity types ({}):", types.len());
            for entity_type in &types {
                let count = assembler_scripts::r2_entity::loadEntities(entity_type).len();
                println!("  {} ({} entities)", entity_type, count);
            }
        }
    }
    Ok(())
}

fn cmd_count() -> anyhow::Result<()> {
    let types = assembler_scripts::r2_paths::entityTypes();
    let mut rows: Vec<Vec<String>> = Vec::new();
    for entity_type in &types {
        let count = assembler_scripts::r2_entity::loadEntities(entity_type).len();
        rows.push(vec![entity_type.clone(), count.to_string()]);
    }
    println!("{}", assembler_scripts::r0_report::formatTable(&rows, &["Entity Type", "Count"]));
    Ok(())
}

fn cmd_check(check: CheckCommand) -> anyhow::Result<()> {
    let entries = assembler_scripts::r2_entity::loadAllEntities();
    let allIds: std::collections::HashSet<&str> = entries.iter().map(|e| e.id.as_str()).collect();

    match check {
        CheckCommand::IdMatch => {
            let faults = assembler_scripts::r2_check_id_match::checkIdMatch(&entries);
            println!("{}", assembler_scripts::r0_violation::reportFaults(&faults));
        }
        CheckCommand::RingMatch => {
            let faults = assembler_scripts::r2_check_ring_match::checkRingMatch(&entries);
            println!("{}", assembler_scripts::r0_violation::reportFaults(&faults));
        }
        CheckCommand::Source => {
            let faults = assembler_scripts::r2_check_source::checkSource(&entries, &allIds);
            println!("{}", assembler_scripts::r0_violation::reportFaults(&faults));
        }
        CheckCommand::Precedes => {
            let (faults, cycles) = assembler_scripts::r2_check_precedes::checkPrecedes(&entries);
            if !faults.is_empty() {
                println!("{}", assembler_scripts::r0_violation::reportFaults(&faults));
            }
            if !cycles.is_empty() {
                println!("Precedes cycles ({}):", cycles.len());
                for cycle in &cycles {
                    println!("  {}", cycle);
                }
            }
            if faults.is_empty() && cycles.is_empty() {
                println!("ok — {} entities, all precedes targets valid, 0 cycles", entries.len());
            }
        }
        CheckCommand::StaleRefs => {
            let faults = assembler_scripts::r2_check_stale_refs::checkStaleRefs(&entries);
            println!("{}", assembler_scripts::r0_violation::reportFaults(&faults));
        }
    }
    Ok(())
}

fn cmd_rings() -> anyhow::Result<()> {
    println!("Ring topology per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY:");
    for (group, ring, name) in assembler_scripts::r0_rings::allRings() {
        println!("  {} R{} — {}", group, ring, name);
    }
    Ok(())
}

/// Type-scoped structural audit: id-match, ring-match, source, precedes.
/// Source and precedes resolve against the full entity universe so
/// cross-type references do not false-positive; faults filter to the type.
fn cmd_audit(entity_type: &str) -> anyhow::Result<()> {
    let allEntries = assembler_scripts::r2_entity::loadAllEntities();
    let allIds: std::collections::HashSet<&str> =
        allEntries.iter().map(|entry| entry.id.as_str()).collect();
    let entries = assembler_scripts::r2_entity::loadEntities(entity_type);

    if entries.is_empty() {
        let types = assembler_scripts::r2_paths::entityTypes();
        if !types.iter().any(|entityType| entityType == entity_type) {
            anyhow::bail!("unknown entity type '{}' — valid: {}", entity_type, types.join(", "));
        }
        println!("audit ok — 0 entities of type '{}'", entity_type);
        return Ok(());
    }

    let idFaults = assembler_scripts::r2_check_id_match::checkIdMatch(&entries);
    let ringFaults = assembler_scripts::r2_check_ring_match::checkRingMatch(&entries);
    let sourceFaults = assembler_scripts::r2_check_source::checkSource(&entries, &allIds);
    let (precedesAll, cycles) = assembler_scripts::r2_check_precedes::checkPrecedes(&allEntries);
    let precedesScoped: Vec<assembler_scripts::r0_violation::Fault> = precedesAll
        .into_iter()
        .filter(|fault| fault.entity_type == entity_type)
        .collect();

    println!("== audit: {} ({} entities) ==", entity_type, entries.len());
    println!("-- id-match --");
    println!("{}", assembler_scripts::r0_violation::reportFaults(&idFaults));
    println!("-- ring-match --");
    println!("{}", assembler_scripts::r0_violation::reportFaults(&ringFaults));
    println!("-- source --");
    println!("{}", assembler_scripts::r0_violation::reportFaults(&sourceFaults));
    println!("-- precedes --");
    println!("{}", assembler_scripts::r0_violation::reportFaults(&precedesScoped));
    if !cycles.is_empty() {
        println!("precedes cycles ({}):", cycles.len());
        for cycle in &cycles {
            println!("  {}", cycle);
        }
    }

    let total = idFaults.len() + ringFaults.len() + sourceFaults.len() + precedesScoped.len();
    if total == 0 && cycles.is_empty() {
        println!("audit ok — {} entities of type '{}', 0 faults", entries.len(), entity_type);
    } else {
        println!("audit FAIL — {} faults, {} cycles", total, cycles.len());
    }
    Ok(())
}
