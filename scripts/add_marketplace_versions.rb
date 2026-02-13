#!/usr/bin/env ruby
# frozen_string_literal: true

# Add per-skill version build id and top-level commit SHA to marketplace.json

require 'json'

BUILD_VERSION = ENV.fetch("BUILD_VERSION", "1")
MARKETPLACE_PATH = "marketplace.json"

# Read and parse marketplace.json
marketplace = JSON.parse(File.read(MARKETPLACE_PATH))

# Add version to each skill
if marketplace['skills']
  marketplace['skills'].each do |skill|
    skill['version'] = BUILD_VERSION unless skill['version']
  end
end

# Write back to file with pretty formatting
File.write(MARKETPLACE_PATH, JSON.pretty_generate(marketplace) + "\n")

puts "✓ Updated marketplace.json with per-skill build version #{BUILD_VERSION}"
puts "  - Added build version #{BUILD_VERSION} to #{marketplace['skills']&.size || 0} skills"
