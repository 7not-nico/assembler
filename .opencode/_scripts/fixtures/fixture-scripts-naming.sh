#!/usr/bin/env bash
# fixture-scripts-naming.sh — runs the real _scripts Ruby analyzer r1-entity-naming.rb
# Shape: violation list; probes legacy Ruby toolchain path
cd "$(dirname "$0")/.."
ruby r1-entity-naming.rb
exit $?
