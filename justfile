
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

# Run the checks CI runs.
check: fmt-check
