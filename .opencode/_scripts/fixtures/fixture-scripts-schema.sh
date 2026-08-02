#!/usr/bin/env bash
# fixture-scripts-schema.sh — runs the real _scripts Ruby analyzer r0-schema-validate.rb
# Shape: schema validation report; probes Ruby stdlib validation
cd "$(dirname "$0")/.."
ruby r0-schema-validate.rb
exit $?
