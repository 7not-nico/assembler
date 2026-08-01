# exports: (side effects) loads all external Ruby dependencies
# purity: LOCAL-READ — loads gems from system
# depends-on: Gemfile in same directory

require "json"
require "yaml"
require "sqlite3"
