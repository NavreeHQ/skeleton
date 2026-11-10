//! The migrations of the customers module. `navree migrate` runs every module's set
//! in dependency order and each set in name order;
//! `navree make:migration customers <name>` adds one here.

use navree::db::MigrationSet;
use navree::schema::migration;

mod m20261111_044813_create_customers_table;

/// The module's migration set.
pub fn migrations() -> MigrationSet {
    MigrationSet::new("customers").migration(migration!(m20261111_044813_create_customers_table))
}
