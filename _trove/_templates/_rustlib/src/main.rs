//! CLI shell for templates_ann library. Reads JSON on stdin, writes JSON on stdout.
//!
//! Usage:
//!   echo '<json>' | tpl-ann score
//!   echo '<json>' | tpl-ann hit
//!   echo '<json>' | tpl-ann unit

use std::io::Read;

// ── Functions: one word, singular concrete noun, lower ──

/// Cosine score: {"first": [f32], "second": [f32]} → {"score": f32}
fn score() -> Result<String, String> {
    let input = stdin()?;
    let map: serde_json::Value = serde_json::from_str(&input)
        .map_err(|e| format!("json: {}", e))?;

    let left = map.get("first").and_then(|v| v.as_array())
        .ok_or("missing 'first'")?;
    let right = map.get("second").and_then(|v| v.as_array())
        .ok_or("missing 'second'")?;

    let left: Vec<f32> = left.iter().map(|v| {
        v.as_f64().ok_or("non-numeric in 'first'").map(|x| x as f32)
    }).collect::<Result<Vec<_>, _>>()?;
    let right: Vec<f32> = right.iter().map(|v| {
        v.as_f64().ok_or("non-numeric in 'second'").map(|x| x as f32)
    }).collect::<Result<Vec<_>, _>>()?;

    let score = templates_ann::vector::score(&left, &right);
    Ok(serde_json::json!({ "score": score }).to_string())
}

/// Nearest hits: {"query": [f32], "vector": [[f32]], "k": u64} → {"hit": [{index, score}]}
fn hit() -> Result<String, String> {
    let input = stdin()?;
    let map: serde_json::Value = serde_json::from_str(&input)
        .map_err(|e| format!("json: {}", e))?;

    let query = array(map.get("query").ok_or("missing 'query'")?)?;
    let pool = map.get("vector").and_then(|v| v.as_array())
        .ok_or("missing 'vector'")?;
    let k = map.get("k").and_then(|v| v.as_u64()).unwrap_or(10) as usize;

    let vector: Vec<Vec<f32>> = pool.iter()
        .map(|v| array(v))
        .collect::<Result<Vec<_>, _>>()?;

    let list: Vec<serde_json::Value> = templates_ann::index::hit(&query, &vector, k)
        .iter().map(|h| serde_json::json!({ "index": h.index, "score": h.score })).collect();
    Ok(serde_json::json!({ "hit": list }).to_string())
}

/// Batch hits: {"queries": [[f32]...], "vector": [[f32]], "k": u64}
/// → {"hit": [[{index, score}]...]} — one spawn serves many queries (no per-query stall)
fn batch() -> Result<String, String> {
    let input = stdin()?;
    let map: serde_json::Value = serde_json::from_str(&input)
        .map_err(|e| format!("json: {}", e))?;

    let queries = map.get("queries").and_then(|v| v.as_array())
        .ok_or("missing 'queries'")?;
    let pool = map.get("vector").and_then(|v| v.as_array())
        .ok_or("missing 'vector'")?;
    let k = map.get("k").and_then(|v| v.as_u64()).unwrap_or(10) as usize;

    let query_vec: Vec<Vec<f32>> = queries.iter()
        .map(|v| array(v))
        .collect::<Result<Vec<_>, _>>()?;
    let pool_vec: Vec<Vec<f32>> = pool.iter()
        .map(|v| array(v))
        .collect::<Result<Vec<_>, _>>()?;

    let per_query: Vec<Vec<serde_json::Value>> = templates_ann::index::batch(&query_vec, &pool_vec, k)
        .iter()
        .map(|hits| hits.iter().map(|h| serde_json::json!({ "index": h.index, "score": h.score })).collect())
        .collect();
    Ok(serde_json::json!({ "hit": per_query }).to_string())
}

/// Unit vector: {"vector": [f32]} → {"unit": [f32]}
fn unit() -> Result<String, String> {
    let input = stdin()?;
    let map: serde_json::Value = serde_json::from_str(&input)
        .map_err(|e| format!("json: {}", e))?;

    let source = array(map.get("vector").ok_or("missing 'vector'")?)?;
    let unit = templates_ann::vector::unit(&source);
    Ok(serde_json::json!({ "unit": unit }).to_string())
}

/// Read stdin into string
fn stdin() -> Result<String, String> {
    let mut source = String::new();
    std::io::stdin().read_to_string(&mut source).map_err(|e| format!("stdin: {}", e))?;
    Ok(source)
}

/// Parse JSON value into Vec<f32>
fn array(item: &serde_json::Value) -> Result<Vec<f32>, String> {
    item.as_array()
        .ok_or("expected array".to_string())?
        .iter()
        .map(|x| x.as_f64().ok_or("non-numeric".to_string()).map(|x| x as f32))
        .collect()
}

// ── Entry ──

fn main() {
    let line: Vec<String> = std::env::args().collect();
    let verb = line.get(1).map(|s| s.as_str()).unwrap_or("");

    let result = match verb {
        "score" => score(),
        "hit"   => hit(),
        "batch" => batch(),
        "unit"  => unit(),
        _ => Err("usage: tpl-ann <score|hit|batch|unit>\n  Pipe JSON to stdin".to_string()),
    };

    match result {
        Ok(text) => println!("{}", text),
        Err(msg) => {
            eprintln!("Error: {}", msg);
            std::process::exit(1);
        }
    }
}
