//! Pure vector math — cosine score, L2 norm, dot product, unit normalize
//! All functions deterministic: same input → same output. No I/O, no side effects.

/// Cosine score between two slices
pub fn score(a: &[f32], b: &[f32]) -> f32 {
    let mut dot = 0.0_f32;
    let mut la = 0.0_f32;
    let mut ra = 0.0_f32;
    for i in 0..a.len() {
        dot += a[i] * b[i];
        la += a[i] * a[i];
        ra += b[i] * b[i];
    }
    let norm = la.sqrt() * ra.sqrt();
    if norm == 0.0 { 0.0 } else { dot / norm }
}

/// Dot product between two slices
pub fn product(a: &[f32], b: &[f32]) -> f32 {
    let mut dot = 0.0_f32;
    for i in 0..a.len() {
        dot += a[i] * b[i];
    }
    dot
}

/// L2 norm (Euclidean length) of a slice
pub fn norm(value: &[f32]) -> f32 {
    let mut sum = 0.0_f32;
    for i in 0..value.len() {
        sum += value[i] * value[i];
    }
    sum.sqrt()
}

/// Unit vector (L2-normalized copy) of a slice
pub fn unit(value: &[f32]) -> Vec<f32> {
    let len = norm(value);
    if len == 0.0 {
        return vec![0.0_f32; value.len()];
    }
    value.iter().map(|x| x / len).collect()
}
