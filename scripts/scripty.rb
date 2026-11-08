# frozen_string_literal: true

require 'pathname'

# A few functions useful in scripts
module Scripty
  ROOT = Pathname.new(`git rev-parse --show-toplevel`.chomp)

  # Suppress echo when run in RubyMine console
  if ENV['RM_INFO'] || ENV['RUBYLIB']&.include?('rubymine')
    require 'io/console'
    $stdin.echo = false if $stdin.tty?
  end

  module_function

  # Answers to the questions, given on the command line (see bump.rb); a question with no answer is asked
  ANSWERS = {} # rubocop:disable Style/MutableConstant -- filled by the command line options

  # Answer the question identified by key: from ANSWERS, or asking at the terminal
  def answer?(key, question)
    ANSWERS.fetch(key) do
      print "#{question} (y/n)> "
      gets.chomp.start_with?(/y/i)
    end
  end

  # Ask for confirmation and do
  def confirm_to(key, action)
    yield if answer?(key, "Do you want to #{action}?")
  end

  # Optional edit
  def edit_file?(key, filepath, caption = filepath)
    filepath = ROOT.join(filepath)
    puts "\n#{caption}:"
    puts filepath.read
    return false unless answer?(key, "Do you want to edit #{caption.inspect}?")

    # Use the environment EDITOR or default to nano
    editor = ENV['EDITOR'] || 'nano'
    system(editor, filepath.to_s)
  end

  # Replace a string in filepath
  def replace_string_in_file(filepath, search, replace, all: false)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    all ? content.gsub!(search, replace) : content.sub!(search, replace)
    filepath.write(content)
  end

  # Extract a section from filepath
  def extract_section_from_file(filepath, section)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    content[/<!-- #{section}_start -->\n(.*)<!-- #{section}_end -->/m, 1]
  end

  # Replace a section in filepath
  def replace_section_in_file(filepath, section, new_content)
    filepath = ROOT.join(filepath)
    content  = filepath.read
    content.sub!(/<!-- #{section}_start -->\n.*<!-- #{section}_end -->/m,
                 "<!-- #{section}_start -->\n#{new_content}<!-- #{section}_end -->")
    filepath.write(content)
  end

  # Generate a gitlog filtering by 💎 and checking for missing ones
  def generate_gem_log(old_version)
    gitlog  = Tempfile.new
    commits = `git rev-list "#{old_version}"..HEAD`.split("\n")
    missing = []

    commits.each do |commit|
      subject = `git show --no-patch --format="%s" #{commit}`.chomp

      if subject.start_with?('💎')
        gitlog.puts "- #{subject.sub('💎', '').strip}"
        body = `git show --no-patch --format="%b" #{commit}`.chomp
        unless body.empty?
          lines = body.split("\n")
          body  = lines.map { |line| "  #{line}" }.join("\n")
          gitlog.puts body
        end
      elsif `git show --format="" -w -p --relative=gem #{commit}`.strip.length.positive?
        # If no diamond, but meaningful changes (ignoring whitespace) in gem/ detected
        missing << "- #{commit[0..6]} #{subject}"
      end
    end

    unless missing.empty?
      puts "\nThe following commits contain changes in the gem dir, but are not marked with the 💎:"
      puts missing
      confirm_to(:abort_on_unmarked, 'abort and manually edit the commit messages') do
        system('git reset --hard')
        abort
      end
    end

    gitlog.close
    gitlog
  end
end
