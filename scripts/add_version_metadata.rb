#!/usr/bin/env ruby
# frozen_string_literal: true

# Add version build id to metadata block in all SKILL.md files

require 'yaml'

VERSION = "1"

skill_files = Dir.glob("skills/*/SKILL.md").reject { |f| f.include?("_drafts") }

puts "Processing #{skill_files.size} SKILL.md files..."

skill_files.each do |file_path|
  content = File.read(file_path)

  # Extract frontmatter
  if content =~ /\A---\n(.*?)\n---\n/m
    frontmatter = $1
    body = $'

    # Parse YAML
    data = YAML.safe_load(frontmatter, permitted_classes: [Symbol])

    # Add version to metadata if not already present
    if data['metadata']
      unless data['metadata']['version']
        data['metadata']['version'] = VERSION

        # Convert back to YAML
        new_frontmatter = YAML.dump(data).sub(/\A---\n/, '')
        new_content = "---\n#{new_frontmatter}---\n#{body}"

        File.write(file_path, new_content)
        puts "✓ Updated #{file_path}"
      else
        puts "⊘ Skipped #{file_path} (version already exists)"
      end
    else
      puts "✗ Error: No metadata block in #{file_path}"
    end
  else
    puts "✗ Error: No frontmatter in #{file_path}"
  end
end

puts "\nDone!"
