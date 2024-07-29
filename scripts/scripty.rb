# frozen_string_literal: true

require 'pathname'

# A few functions useful in scripts
module Scripty
  ROOT = Pathname.new(`git rev-parse --show-toplevel`.chomp)

  # Ask for confirmation and do
  def ask_and_do(question)
    print question
    yield if gets.chomp.start_with?(/y/i)
  end
  module_function :ask_and_do

  # Warn and exit
  def abort(message)
    warn message
    exit 1
  end
  module_function :abort

  # Optional edit
  def file_edit?(name, filepath)
    filepath = ROOT.join(filepath).to_s
    puts "\n#{name}:"
    puts File.read(filepath)
    print "Do you want to edit #{name.inspect}? (y/n)> "
    system("nano #{filepath}") if gets.chomp.start_with?(/y/i)
  end
  module_function :file_edit?

  # Substitute a string in filepth
  def file_sub(filepath, search, replace)
    filepath = ROOT.join(filepath).to_s
    content  = File.read(filepath)
    content.sub!(search, replace)
    File.write(filepath, content)
  end
  module_function :file_sub

  # Substitute a tagged string in filepth
  def tagged_file_sub(filepath, tag, new_content)
    filepath = ROOT.join(filepath).to_s
    content  = File.read(filepath)
    content.sub!(/<!-- #{tag}_start -->\n.*<!-- #{tag}_end -->/m,
                 "<!-- #{tag}_start -->\n#{new_content}<!-- #{tag}_end -->")
    File.write(filepath, content)
  end
  module_function :tagged_file_sub

  def tagged_extract(filepath, tag)
    filepath = ROOT.join(filepath).to_s
    content  = File.read(filepath)
    content[/<!-- #{tag}_start -->\n(.*)<!-- #{tag}_end -->/m, 1]
  end
  module_function :tagged_extract
end
