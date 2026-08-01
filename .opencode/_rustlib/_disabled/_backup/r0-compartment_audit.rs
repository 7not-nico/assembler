// ring: 0 (PURE)
//! Compartment declaration parsing and audit
//! port of _lib/compartment-audit.ts

/// Compartment declaration from YAML
#[derive(Debug, Clone)]
pub struct CompartmentMembrane {
    pub membraneType: String,
    pub processFamily: String,
    pub governance: String,
    pub channels: Vec<ChannelSpec>,
}

/// Cross-compartment channel specification
#[derive(Debug, Clone)]
pub struct ChannelRoute {
    pub target: String,
    pub protocol: String,
}

/// Audit violation for a compartment
#[derive(Debug, Clone)]
pub struct CompartmentFault {
    pub field: String,
    pub message: String,
}

/// Audit result for a compartment
#[derive(Debug, Clone)]
pub struct CompartmentOutcome {
    pub name: String,
    pub path: String,
    pub present: bool,
    pub violations: Vec<CompartmentViolation>,
}

const VALID_MEMBRANE_TYPES: &[&str] = &["autonomous", "shared-substrate", "infrastructure"];

/// Parse a compartment declaration from key-value text
pub fn compartmentDeclaration(text: &str) -> Option<CompartmentDeclaration> {
    let mut membraneType = String::new();
    let mut processFamily = String::new();
    let mut governance = String::new();
    let mut channels: Vec<ChannelSpec> = Vec::new();
    let mut inChannels = false;

    for line in text.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() || trimmed.starts_with('#') { continue; }
        if trimmed.starts_with("cross-compartment-channels:") {
            inChannels = true;
            continue;
        }
        if inChannels {
            if let Some(target) = trimmed.strip_prefix("- target:") {
                channels.push(ChannelSpec { target: target.trim().to_string(), protocol: String::new() });
                continue;
            }
            if let Some(protocol) = trimmed.strip_prefix("protocol:") {
                if let Some(last) = channels.last_mut() {
                    last.protocol = protocol.trim().to_string();
                }
                continue;
            }
            if trimmed.starts_with("- ") || trimmed.chars().next().map(|c| c.is_alphanumeric()).unwrap_or(false) {
                inChannels = false;
            } else {
                continue;
            }
        }
        if let Some((key, value)) = trimmed.split_once(':') {
            match key.trim() {
                "membrane-type" => membraneType = value.trim().to_string(),
                "process-family" => processFamily = value.trim().to_string(),
                "governance" => governance = value.trim().to_string(),
                _ => {}
            }
        }
    }

    if membraneType.is_empty() && processFamily.is_empty() && governance.is_empty() && channels.is_empty() {
        return None;
    }
    Some(CompartmentDeclaration { membraneType, processFamily, governance, channels })
}

/// Membrane type audit — validates field values
pub fn membraneAudit(decl: &CompartmentDeclaration) -> Vec<CompartmentViolation> {
    let mut violations = Vec::new();

    if decl.membraneType.is_empty() {
        violations.push(CompartmentViolation { field: "membrane-type".to_string(), message: "Missing required field".to_string() });
    } else if !VALID_MEMBRANE_TYPES.contains(&decl.membraneType.as_str()) {
        violations.push(CompartmentViolation {
            field: "membrane-type".to_string(),
            message: format!("Invalid value \"{}\". Valid: {}", decl.membraneType, VALID_MEMBRANE_TYPES.join(", ")),
        });
    }

    if decl.processFamily.is_empty() {
        violations.push(CompartmentViolation { field: "process-family".to_string(), message: "Missing required field".to_string() });
    }
    if decl.governance.is_empty() {
        violations.push(CompartmentViolation { field: "governance".to_string(), message: "Missing required field".to_string() });
    }
    if decl.channels.len() > 1 {
        violations.push(CompartmentViolation {
            field: "cross-compartment-channels".to_string(),
            message: format!("Channel count {} exceeds maximum 1 per direction", decl.channels.len()),
        });
    }

    violations
}

/// Full compartment audit from raw text
pub fn compartmentAudit(text: &str) -> Vec<CompartmentViolation> {
    match compartmentDeclaration(text) {
        Some(decl) => membraneAudit(&decl),
        None => vec![CompartmentViolation { field: "(root)".to_string(), message: "No compartment declaration found".to_string() }],
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_compartment_declaration() {
        let text = "membrane-type: autonomous\nprocess-family: build\ngovernance: team\n";
        let decl = compartmentDeclaration(text).unwrap();
        assert_eq!(decl.membraneType, "autonomous");
        assert_eq!(decl.processFamily, "build");
    }

    #[test]
    fn test_membrane_audit_missing() {
        let decl = CompartmentDeclaration {
            membraneType: String::new(),
            processFamily: String::new(),
            governance: String::new(),
            channels: vec![],
        };
        let violations = membraneAudit(&decl);
        assert_eq!(violations.len(), 3);
    }
}
