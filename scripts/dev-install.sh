#!/bin/bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
MARKETPLACE_NAME="claude-code-toolkit"

PLUGIN_NAMES=(
  "fullstack-dev"
  "code-review"
  "erd-skill"
)

# Add marketplace
if ! claude plugin marketplace add "$ROOT_DIR"; then
  claude plugin marketplace remove "$MARKETPLACE_NAME"
  claude plugin marketplace add "$ROOT_DIR"
fi

# Install plugins
for PLUGIN_NAME in "${PLUGIN_NAMES[@]}"; do
  claude plugin install "$PLUGIN_NAME@$MARKETPLACE_NAME"
done
