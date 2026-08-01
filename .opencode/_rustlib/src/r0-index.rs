//! Nearest hit search — flat brute-force search over all vectors
//! All functions deterministic: same input → same output. No I/O, no side effects.

/// Hit — a search result: position in collection + match strength
pub struct Hit {
    pub index: usize,
    pub score: f32,
}

/// Find k nearest hits from a query against a collection of raw vectors
pub fn hit(query: &[f32], vector: &[Vec<f32>], k: usize) -> Vec<Hit> {
    let mut result: Vec<Hit> = vector.iter().enumerate().map(|(idx, v)| {
        let score = super::vector::score(query, v);
        Hit { index: idx, score }
    }).collect();

    result.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));
    result.truncate(k);
    result
}
