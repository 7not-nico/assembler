#![allow(non_snake_case)]
//! Fault formatting — port of _rb/Fault.rb
//! ring: 0 (PURE)
//! contract: Fault struct holds audit findings. report_Faults formats as table.
//!   run_audit iterates entries with a check closure.
//! purity: pure (no I/O)

use crate::r0_report as report;

#[derive(Debug, Clone)]
pub struct Fault {
    pub id: String,
    pub entity_type: String,
    pub field: String,
    pub value: String,
    pub problem: String,
}

pub fn reportFaults(_Faults: &[Fault]) -> String {
    if _Faults.is_empty() {
        return "ok — 0 _Faults".to_string();
    }
    let headers = vec!["ID", "Type", "Field", "Value", "Problem"];
    let rows: Vec<Vec<String>> = _Faults
        .iter()
        .map(|Fault| {
            vec![
                Fault.id.clone(),
                Fault.entity_type.clone(),
                Fault.field.clone(),
                Fault.value.clone(),
                Fault.problem.clone(),
            ]
        })
        .collect();
    format!(
        "Faults ({}):\n{}",
        _Faults.len(),
        report::formatTable(&rows, &headers)
    )
}

pub fn runAudit<F>(entries: &[crate::r2_entity::EntityEntry], mut check: F) -> Vec<Fault>
where
    F: FnMut(&crate::r2_entity::EntityEntry, &mut Vec<Fault>),
{
    let mut _Faults = Vec::new();
    for entry in entries {
        check(entry, &mut _Faults);
    }
    _Faults
}
