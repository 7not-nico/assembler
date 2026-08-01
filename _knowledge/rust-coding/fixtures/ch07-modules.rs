// source: https://doc.rust-lang.org/stable/book/ch07-01-packages-and-crates.html
// module: ch07 — modules, pub, use, paths, super, self
// compile: rustc ch07-modules.rs && ./ch07-modules -> prints all values
#![allow(dead_code)]

// ── Top-level module defined inline ──
// mod creates a namespace; items private by default
mod garden {
    // pub makes item visible outside the module
    pub fn water() -> String {
        String::from("watering plants")
    }

    // Private function — accessible only within garden module
    fn fertilize() -> String {
        String::from("fertilizing")
    }

    // Nested module — pub to be accessible from parent
    pub mod vegetables {
        pub fn grow() -> String {
            // super goes up one level: garden::fertilize
            super::fertilize()
        }
    }
}

// ── Module with struct and fields ──
mod inventory {
    // Struct can be pub but its fields default private
    pub struct Tool {
        name: String,           // private field
        pub quantity: u32,      // public field
    }

    impl Tool {
        // Constructor needed since name field is private
        pub fn new(name: &str, quantity: u32) -> Tool {
            Tool { name: String::from(name), quantity }
        }
    }

    // Free function getter — replaces fn label(&self)
    pub fn label(tool: &Tool) -> &str {
        &tool.name
    }
}

// ── Module with enum ──
mod season {
    // Enum variants are pub when enum is pub
    pub enum Weather {
        Sunny,
        Rainy,
        Cloudy,
    }
}

fn main() {
    // Absolute path: crate root -> garden -> water
    // crate refers to the current crate root
    let task = crate::garden::water();
    println!("{task}");

    // Relative path: self -> garden -> vegetables -> grow
    let output = self::garden::vegetables::grow();
    println!("{output}");

    // Use brings paths into scope
    use crate::garden::water as irrigate;
    println!("{}", irrigate());

    // Struct with pub and private fields
    use crate::inventory::Tool;
    let shovel = Tool::new("shovel", 3);
    // println!("{}", shovel.name);     // compile: field is private
    println!("{} qty={}", inventory::label(&shovel), shovel.quantity);

    // Enum with pub variants
    use crate::season::Weather;
    let sky = Weather::Sunny;
    match sky {
        Weather::Sunny => println!("sunny day"),
        Weather::Rainy => println!("rainy day"),
        Weather::Cloudy => println!("cloudy day"),
    }

    // self:: refers to current module (main's scope)
    let msg = self::greet();
    println!("{msg}");

    // use re-export with pub use
    pub use crate::garden::water as reexport_water;
    println!("{}", reexport_water());
}

fn greet() -> String {
    String::from("hello from crate root")
}
