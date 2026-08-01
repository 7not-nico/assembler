// ring: 0 (PURE)
//! Reciprocal rank fusion — merge search result

use crate::structs::SearchResult;

pub const RrfFactor: f64 = 60.0;

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct RankedItem {
    pub entitytype: String,
    pub entityid: String,
    pub rank: u32,
}

pub fn fusion(
    vectoritem: &[RankedItem],
    keyworditem: &[RankedItem],
    limit: usize,
) -> Vec<SearchResult> {
    use std::collections::HashMap;
    let mut merge: HashMap<String, SearchResult> = HashMap::new();

    for item in vectoritem {
        let key = format!("{}:{}", item.entitytype, item.entityid);
        let score = 1.0 / (RrfFactor + item.rank as f64);
        merge.insert(key, SearchResult {
            entitytype: item.entitytype.clone(),
            entityid: item.entityid.clone(),
            score,
            source: Some("hybrid".to_string()),
        });
    }

    for item in keyworditem {
        let key = format!("{}:{}", item.entitytype, item.entityid);
        let score = 1.0 / (RrfFactor + item.rank as f64);
        if let Some(prior) = merge.get_mut(&key) {
            prior.score += score;
        } else {
            merge.insert(key, SearchResult {
                entitytype: item.entitytype.clone(),
                entityid: item.entityid.clone(),
                score,
                source: Some("hybrid".to_string()),
            });
        }
    }

    let mut result: Vec<SearchResult> = merge.into_values().collect();
    result.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));
    result.truncate(limit);
    for r in &mut result {
        r.score = (r.score * 1000.0).round() / 1000.0;
    }
    result
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn fusion_merge() {
        let v = vec![RankedItem { entitytype: "maxims".to_string(), entityid: "MAX.DRY".to_string(), rank: 0 }];
        let k = vec![RankedItem { entitytype: "maxims".to_string(), entityid: "MAX.DRY".to_string(), rank: 0 }];
        let r = fusion(&v, &k, 5);
        assert_eq!(r.len(), 1);
    }
}
