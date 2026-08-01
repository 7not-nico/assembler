//! r0-vector.rs — pure vector math: cosine score, L2 unit norm.
//! Ring 0 (PURE): no I/O, no allocation surprises, deterministic.

/// Cosine score between two equal-length slices.
/// Returns 0 for zero-norm inputs.
pub fn score(left: &[f32], right: &[f32]) -> f32 {
    let mut dot = 0.0f64;
    let mut la = 0.0f64;
    let mut ra = 0.0f64;
    for index in 0..left.len().min(right.len()) {
        dot += left[index] as f64 * right[index] as f64;
        la += left[index] as f64 * left[index] as f64;
        ra += right[index] as f64 * right[index] as f64;
    }
    let norm = (la * ra).sqrt();
    if norm == 0.0 {
        0.0
    } else {
        (dot / norm) as f32
    }
}

/// L2-normalized copy of a slice. Zero-norm input yields a zero vector.
pub fn unit(source: &[f32]) -> Vec<f32> {
    let sum: f64 = source.iter().map(|x| (*x as f64) * (*x as f64)).sum();
    let len = sum.sqrt();
    if len == 0.0 {
        return vec![0.0; source.len()];
    }
    source.iter().map(|x| (*x as f32) / len as f32).collect()
}
