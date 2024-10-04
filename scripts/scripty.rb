# frozen_string_literal: true

require 'pathname'

# A few functions useful in scripts
module Scripty
  ROOT = Pathname.new(`git rev-parse --show-toplevel`.chomp)

  # Ask for confirmation and do
  def confirm_to(action)
    print %(Do you want to #{action}? (y/n)> )
    yield if gets.chomp.start_with?(/y/i)
  end

  # Optional edit
  def edit_file?(filepath, caption = filepath)
    filepath = ROOT.join(filepath)
    puts "\n#{caption}:"
    puts filepath.read
    print "Do you want to edit #{caption.inspect}? (y/n)> "
    system("nano #{filepath}") if gets.chomp.start_with?(/y/i)
  end

  # Replace a string in filepth
  def replace_string_in_file(filepath, search, replace)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    content.sub!(search, replace)
    filepath.write(content)
  end

  # Extract a section from filepth
  def extract_section_from_file(filepath, section)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    content[/<!-- #{section}_start -->\n(.*)<!-- #{section}_end -->/m, 1]
  end

  # Replace a section in filepth
  def replace_section_in_file(filepath, section, new_content)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    content.sub!(/<!-- #{section}_start -->\n.*<!-- #{section}_end -->/m,
                 "<!-- #{section}_start -->\n#{new_content}<!-- #{section}_end -->")
    filepath.write(content)
  end
end
