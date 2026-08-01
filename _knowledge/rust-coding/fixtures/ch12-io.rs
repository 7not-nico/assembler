// source: https://doc.rust-lang.org/stable/book/ch12-01-accepting-command-line-arguments.html
// module: ch12 — CLI args, file reading, search, env vars, stderr
// compile: rustc --test ch12-io.rs -o /tmp/ch12-io && /tmp/ch12-io

use std::env;

// ── Config: parsed command line arguments ──
struct Config {
    query: String,
    path: String,
    casefold: bool,
}

fn config(args: &[String]) -> Result<Config, String> {
    if args.len() < 3 {
        return Err(String::from("usage: program <query> <file>"));
    }
    let query = args[1].clone();
    let path = args[2].clone();

    // Check environment variable IGNORE_CASE
    let casefold = env::var("IGNORE_CASE").is_ok();

    Ok(Config { query, path, casefold })
}

// ── File reading ──
fn reader(path: &str) -> Result<String, String> {
    std::fs::read_to_string(path).map_err(|e| format!("read error: {e}"))
}

// ── Search logic ──
fn finder<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let mut result = Vec::new();
    for line in contents.lines() {
        if line.contains(query) {
            result.push(line);
        }
    }
    result
}

fn caseless<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let lower = query.to_lowercase();
    let mut result = Vec::new();
    for line in contents.lines() {
        if line.to_lowercase().contains(&lower) {
            result.push(line);
        }
    }
    result
}

// ── Run function: orchestrates the tool ──
fn pipeline(cfg: &Config) -> Result<(), String> {
    let content = reader(&cfg.path)?;

    let lines = if cfg.casefold {
        caseless(&cfg.query, &content)
    } else {
        finder(&cfg.query, &content)
    };

    for line in lines {
        println!("{line}");
    }

    Ok(())
}

// ── Binary entry point (disabled in test mode) ──
fn main() {
    let args: Vec<String> = env::args().collect();
    let cfg = match config(&args) {
        Ok(c) => c,
        Err(msg) => {
            eprintln!("{msg}");
            std::process::exit(1);
        }
    };

    if let Err(msg) = pipeline(&cfg) {
        eprintln!("error: {msg}");
        std::process::exit(1);
    }
}

// ─── Tests ───

#[cfg(test)]
mod unit {
    use super::*;

    #[test]
    fn search_found() {
        let query = "duct";
        let content = "\
Rust:
safe, fast, productive.
Pick three.";
        let result = finder(query, content);
        assert_eq!(result, vec!["safe, fast, productive."]);
    }

    #[test]
    fn search_not_found() {
        let query = "nope";
        let content = "\
Rust:
safe, fast, productive.";
        let result = finder(query, content);
        let empty: Vec<&str> = Vec::new();
        assert_eq!(result, empty);
    }

    #[test]
    fn case_insensitive() {
        let query = "rUsT";
        let content = "\
Rust:
safe, fast, productive.
Trust me.";
        let result = caseless(query, content);
        assert_eq!(result, vec!["Rust:", "Trust me."]);
    }

    #[test]
    fn config_valid() {
        let args = vec![
            String::from("prog"),
            String::from("query"),
            String::from("file.txt"),
        ];
        let cfg = config(&args).unwrap();
        assert_eq!(cfg.query, "query");
        assert_eq!(cfg.path, "file.txt");
    }

    #[test]
    fn config_missing_args() {
        let args = vec![String::from("prog")];
        let result = config(&args);
        assert!(result.is_err());
    }
}
