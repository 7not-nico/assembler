// ring: 0 (PURE)
//! Burst state and event detection

pub const WindowMs: u64 = 2000;
pub const BurstThreshold: usize = 5;
pub const CooldownMs: u64 = 5000;

#[derive(Debug, Clone)]
pub struct FileEvent {
    pub file: String,
    pub time: u64,
}

#[derive(Debug, Clone)]
pub struct BurstState {
    pub fileevents: Vec<FileEvent>,
    pub lastalerttime: u64,
    pub alertcount: u32,
}

impl BurstState {
    pub fn new() -> Self {
        Self { fileevents: Vec::new(), lastalerttime: 0, alertcount: 0 }
    }

    pub fn check(&self, file: &str, now: u64) -> Self {
        let mut events = self.fileevents.clone();
        events.push(FileEvent { file: file.to_string(), time: now });
        let cutoff = now.saturating_sub(WindowMs);
        events.retain(|e| e.time >= cutoff);
        let mut unique = std::collections::HashSet::new();
        let clone = events.clone();
        for e in &clone { unique.insert(&e.file); }
        let mut state = Self { fileevents: events, lastalerttime: self.lastalerttime, alertcount: self.alertcount };
        if unique.len() >= BurstThreshold && now.saturating_sub(self.lastalerttime) >= CooldownMs {
            state.lastalerttime = now;
            state.alertcount += 1;
        }
        state
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_burst() {
        let s = BurstState::new();
        let s = s.check("a.md", 1000).check("b.md", 1010).check("c.md", 1020).check("d.md", 1030).check("e.md", 1040);
        assert_eq!(s.alertcount, 1);
    }
}
