#!/bin/bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
MARKETPLACE_NAME="claude-code-toolkit"
PLUGIN_NAME="$1"

# Add marketplace
if ! claude plugin marketplace add "$ROOT_DIR"; then
  claude plugin marketplace remove "$MARKETPLACE_NAME"
  claude plugin marketplace add "$ROOT_DIR"
fi

# Add target plugin
claude plugin install "$PLUGIN_NAME@$MARKETPLACE_NAME"
