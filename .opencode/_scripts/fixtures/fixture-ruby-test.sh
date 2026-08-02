#!/usr/bin/env bash
# fixture-ruby-test.sh — wrapper running the functional Ruby toolchain fixture
# Shape: KEY=value contract; probes Ruby runtime + Go CLI integration
cd "$(dirname "$0")"
ruby fixture-ruby-test.rb
exit $?
