//! Skeleton: a Navree app.
//!
//! [`app`] assembles the root module; `src/main.rs` runs it and the tests in
//! `tests/` boot it. Features live in `src/modules/<name>/`
//! (`navree make:module <name> --crud` adds one).
//!
//! The screens are drawn on the server with Navree UI: `src/ui/` holds the
//! shell, who is signed in and the live topic, and `src/modules/customers/`
//! the pages of the example feature.

pub mod abilities;
pub mod modules;
pub mod ui;

mod app;

pub use app::app;
