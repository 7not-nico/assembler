// ring: 0 (PURE)
//! Burst event detection

pub const WindowDuration: u64 = 2000;
pub const BurstThreshold: usize = 5;
pub const CooldownDuration: u64 = 5000;

#[derive(Debug, Clone)]
pub struct FileEvent {
    pub file: String,
    pub time: u64,
}

#[derive(Debug, Clone)]
pub struct BurstState {
    pub event: Vec<FileEvent>,
    pub lasthush: u64,
    pub alertcount: u32,
}

impl BurstState {
    pub fn createState() -> Self {
        Self { event: Vec::new(), lasthush: 0, alertcount: 0 }
    }

    pub fn processEvent(&self, file: &str, now: u64) -> Self {
        let mut event = self.event.clone();
        event.push(FileEvent { file: file.to_string(), time: now });
        let limit = now.saturating_sub(WindowDuration);
        event.retain(|e| e.time >= limit);
        let mut fileset = std::collections::HashSet::new();
        let eventclone = event.clone();
        for entry in &eventclone { fileset.insert(&entry.file); }
        let mut state = Self { event, lasthush: self.lasthush, alertcount: self.alertcount };
        if fileset.len() >= BurstThreshold && now.saturating_sub(self.lasthush) >= CooldownDuration {
            state.lasthush = now;
            state.alertcount += 1;
        }
        state
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn alert_increment_case() {
        let s = BurstState::createState();
        let s = s.processEvent("a.md", 1000).processEvent("b.md", 1010).processEvent("c.md", 1020).processEvent("d.md", 1030).processEvent("e.md", 1040);
        assert_eq!(s.alertcount, 1);
    }
}
