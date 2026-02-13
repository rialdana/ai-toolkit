#!/usr/bin/env ruby
# frozen_string_literal: true

# Add Project Overrides section to all SKILL.md files

require 'yaml'

def skill_name_to_title(name)
  name.split('-').map(&:capitalize).join(' ')
end

def generate_overrides_section(skill_name)
  title = skill_name_to_title(skill_name)

  <<~MARKDOWN


    ## Project Overrides

    Before applying rules from this skill, check if `.claude/overrides/#{skill_name}.md` exists.

    - **If it does not exist**: Create it from the template below, then inform the user.
    - **If it exists**: Read it and apply its instructions over the defaults in this skill.
      Override file instructions take priority over upstream rules.

    ### Override Template

    When creating the override file, use this content:

        # #{title} — Project Overrides
        #
        # This file customizes the upstream #{skill_name} skill for this project.
        # Edit freely — this file is never overwritten by skill updates.
        #
        # ## How to use
        # - **Disable a rule**: "Ignore the <rule-name> rule"
        # - **Modify a rule**: "For <rule-name>, instead do <your preference>"
        # - **Add a rule**: Write your project-specific rule directly
        #
        # Leave sections empty or delete them if you have no overrides.

        ## Disabled Rules

        (none)

        ## Modified Rules

        (none)

        ## Additional Project Rules

        (none)
  MARKDOWN
end

skill_files = Dir.glob("skills/*/SKILL.md").reject { |f| f.include?("_drafts") }

puts "Processing #{skill_files.size} SKILL.md files..."

skill_files.each do |file_path|
  content = File.read(file_path)

  # Extract skill name from frontmatter
  if content =~ /\A---\n(.*?)\n---\n/m
    frontmatter = $1
    data = YAML.safe_load(frontmatter, permitted_classes: [Symbol])
    skill_name = data['name']

    # Check if Project Overrides section already exists
    if content.include?("## Project Overrides")
      puts "⊘ Skipped #{file_path} (Project Overrides already exists)"
      next
    end

    # Add overrides section at the end
    overrides_section = generate_overrides_section(skill_name)
    new_content = content.chomp + overrides_section

    File.write(file_path, new_content)
    puts "✓ Updated #{file_path}"
  else
    puts "✗ Error: No frontmatter in #{file_path}"
  end
end

puts "\nDone!"
