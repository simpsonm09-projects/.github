
# List the recipes.
default:
    @just --list

# Install the tools pinned in mise.toml.
install:
    mise install

# Format the files.
fmt:
    bun fmt

# Check formatting without writing.
fmt-check:
    bun fmt --check

# Compare standards/core.md with the other four owner copies.
core-drift:
    bun scripts/core-drift.ts

# Audit every repository of this owner against the core and owner standards.
# `just fleet-audit --timing` adds the C5.1 median pull request CI wall time.
fleet-audit *args:
    bun scripts/fleet-audit.ts {{args}}

# Run the checks CI runs.
check: fmt-check
