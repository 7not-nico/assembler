//! r0-index.rs — pure top-k nearest-neighbor over a vector pool.
//! Ring 0 (PURE): deterministic ranking, no I/O.

use crate::vector;

/// One ranked result: pool index + cosine score.
pub struct Hit {
    pub index: usize,
    pub score: f32,
}

/// Top-k nearest vectors to `query` by cosine similarity.
/// Returns at most `k` hits, sorted descending by score.
pub fn hit(query: &[f32], pool: &[Vec<f32>], k: usize) -> Vec<Hit> {
    let norm = vector::unit(query);
    let mut rank: Vec<Hit> = pool
        .iter()
        .enumerate()
        .map(|(index, item)| Hit {
            index,
            score: vector::score(&norm, item),
        })
        .collect();
    rank.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));
    rank.truncate(k);
    rank
}

/// Batch top-k: one pool, many queries → one ranked list per query.
/// Returns Vec<Vec<Hit>> aligned with `queries` order.
pub fn batch(queries: &[Vec<f32>], pool: &[Vec<f32>], k: usize) -> Vec<Vec<Hit>> {
    queries.iter().map(|q| hit(q, pool, k)).collect()
}
