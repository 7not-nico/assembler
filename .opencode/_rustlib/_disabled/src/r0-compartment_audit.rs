// ring: 0 (PURE)
//! Compartment audit

#[derive(Debug, Clone)]
pub struct ChannelRoute {
    pub target: String,
    pub protocol: String,
}

#[derive(Debug, Clone)]
pub struct CompartmentMap {
    pub membranetype: String,
    pub family: String,
    pub control: String,
    pub channel: Vec<ChannelRoute>,
}

#[derive(Debug, Clone)]
pub struct CompartmentFault {
    pub field: String,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct CompartmentOutcome {
    pub name: String,
    pub path: String,
    pub present: bool,
    pub fault: Vec<CompartmentFault>,
}

const ValidMembrane: &[&str] = &["autonomous", "shared-substrate", "infrastructure"];

pub fn compartmentmap(text: &str) -> Option<CompartmentMap> {
    let mut membranetype = String::new();
    let mut family = String::new();
    let mut control = String::new();
    let mut channel: Vec<ChannelRoute> = Vec::new();
    let mut inchannel = false;

    for line in text.lines() {
        let cleaned = line.trim();
        if cleaned.is_empty() || cleaned.starts_with('#') { continue; }
        if cleaned.starts_with("cross-compartment-channels:") {
            inchannel = true;
            continue;
        }
        if inchannel {
            if let Some(target) = cleaned.strip_prefix("- target:") {
                channel.push(ChannelRoute { target: target.trim().to_string(), protocol: String::new() });
                continue;
            }
            if let Some(protocol) = cleaned.strip_prefix("protocol:") {
                if let Some(last) = channel.last_mut() {
                    last.protocol = protocol.trim().to_string();
                }
                continue;
            }
            if cleaned.starts_with("- ") || cleaned.chars().next().map(|c| c.is_alphanumeric()).unwrap_or(false) {
                inchannel = false;
            } else {
                continue;
            }
        }
        if let Some((key, value)) = cleaned.split_once(':') {
            match key.trim() {
                "membrane-type" => membranetype = value.trim().to_string(),
                "process-family" => family = value.trim().to_string(),
                "governance" => control = value.trim().to_string(),
                _ => {}
            }
        }
    }

    if membranetype.is_empty() && family.is_empty() && control.is_empty() && channel.is_empty() {
        return None;
    }
    Some(CompartmentMap { membranetype, family, control, channel })
}

pub fn membraneaudit(decl: &CompartmentMap) -> Vec<CompartmentFault> {
    let mut fault = Vec::new();

    if decl.membranetype.is_empty() {
        fault.push(CompartmentFault { field: "membrane-type".to_string(), message: "Missing field".to_string() });
    } else if !ValidMembrane.contains(&decl.membranetype.as_str()) {
        fault.push(CompartmentFault { field: "membrane-type".to_string(), message: format!("Invalid \"{}\". Valid: {}", decl.membranetype, ValidMembrane.join(", ")) });
    }

    if decl.family.is_empty() {
        fault.push(CompartmentFault { field: "process-family".to_string(), message: "Missing field".to_string() });
    }
    if decl.control.is_empty() {
        fault.push(CompartmentFault { field: "governance".to_string(), message: "Missing field".to_string() });
    }
    if decl.channel.len() > 1 {
        fault.push(CompartmentFault { field: "cross-compartment-channel".to_string(), message: format!("Channel count {} exceeds 1", decl.channel.len()) });
    }

    fault
}

pub fn compartmentaudit(text: &str) -> Vec<CompartmentFault> {
    match compartmentmap(text) {
        Some(decl) => membraneaudit(&decl),
        None => vec![CompartmentFault { field: "(root)".to_string(), message: "No compartment map found".to_string() }],
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn compartmentmap_case() {
        let text = "membrane-type: autonomous\nprocess-family: build\ngovernance: team\n";
        let decl = compartmentmap(text).unwrap();
        assert_eq!(decl.membranetype, "autonomous");
        assert_eq!(decl.family, "build");
    }

    #[test]
    fn membraneaudit_missing_case() {
        let decl = CompartmentMap { membranetype: String::new(), family: String::new(), control: String::new(), channel: vec![] };
        let fault = membraneaudit(&decl);
        assert_eq!(fault.len(), 3);
    }
}
