#!/usr/bin/env bash
# fixture-scripts-protocol.sh — runs the _scripts r1-protocol-audit launcher
# Shape: protocol audit (bash launcher → Go CLI); probes r1 ring launcher path
cd "$(dirname "$0")/.."
exec bash r1-protocol-audit.rb
