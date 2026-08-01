// source: https://doc.rust-lang.org/stable/book/ch10-02-traits.html
// module: ch10 — trait definition, implementation, trait bounds, impl Trait
// compile: rustc ch10-traits.rs && ./ch10-traits -> prints all values

// ── Trait definition ──
trait Summary {
    fn summarize(&self) -> String;

    // Default implementation — can be overridden
    fn author(&self) -> String {
        String::from("unknown")
    }
}

// ── Trait implementation on a struct ──
#[derive(Debug)]
struct Article {
    title: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}: {}...", self.title, &self.content[..20.min(self.content.len())])
    }
}

// ── Another type implementing the same trait ──
#[derive(Debug)]
struct Tweet {
    username: String,
    body: String,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("@{}: {}", self.username, &self.body[..50.min(self.body.len())])
    }

    // Override default implementation
    fn author(&self) -> String {
        self.username.clone()
    }
}

// ── Trait bound on generic function ──
fn notify<T: Summary>(item: &T) -> String {
    format!("breaking: {}", item.summarize())
}

// ── impl Trait syntax (shorthand) ──
fn alert(item: &impl Summary) -> String {
    format!("alert from {}: {}", item.author(), item.summarize())
}

// ── Multiple trait bounds ──
fn display_pair<T: Summary + std::fmt::Debug>(item: &T) -> String {
    format!("summary: {} | debug: {:?}", item.summarize(), item)
}

// ── where clause for readability ──
fn formatted<T>(item: &T) -> String
where
    T: Summary + std::fmt::Display,
{
    format!("{}. summary: {}", item, item.summarize())
}

// ── Returning impl Trait ──
fn make_summary() -> impl Summary {
    Article {
        title: String::from("hello"),
        content: String::from("world of rust programming"),
    }
}

#[derive(Debug)]
struct Book {
    title: String,
}

impl Summary for Book {
    fn summarize(&self) -> String {
        format!("Book: {}", self.title)
    }
}

// Required for Display bound on Book
impl std::fmt::Display for Book {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Book[{}]", self.title)
    }
}

fn main() {
    let article = Article {
        title: String::from("Rust traits"),
        content: String::from("Traits are like interfaces in other languages."),
    };

    let tweet = Tweet {
        username: String::from("alice"),
        body: String::from("learning Rust traits today! very exciting stuff"),
    };

    // Trait methods called directly
    println!("article: {}", article.summarize());
    println!("tweet: {}", tweet.summarize());

    // Default implementation (not overridden by Article)
    println!("article author: {}", article.author());

    // Overridden implementation
    println!("tweet author: {}", tweet.author());

    // Trait bound on generic function
    println!("{}", notify(&article));

    // impl Trait syntax
    println!("{}", alert(&tweet));

    // Multiple trait bounds
    println!("{}", display_pair(&article));

    // where clause
    let book = Book { title: String::from("The Book") };
    println!("{}", formatted(&book));

    // Returning impl Trait
    let summary = make_summary();
    println!("returned: {}", summary.summarize());
}
