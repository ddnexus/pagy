#!/usr/bin/env ruby
# frozen_string_literal: true

# Regenerate the output of the `ruby Console` examples in the docs, by running each `>> expression`
# in the pagy console and replacing the documented output with the actual one.
# Usage: ruby scripts/update_console_examples.rb [--check]
#   --check  only report the outdated outputs, and exit with status 1 if any

require 'stringio'
require_relative 'scripty'
include Scripty # rubocop:disable Style/MixinUsage

$LOAD_PATH.unshift(ROOT.join('gem/lib').to_s)
require 'pagy/console'

abort 'The docs show the Hash#inspect format of ruby >= 3.4: run this script with ruby >= 3.4' if RUBY_VERSION < '3.4'

CHECK = ARGV.include?('--check')
BLOCK = /^```ruby Console\n(.*?)^```/m

# Each block runs in its own binding, with a default @pagy for the examples that use it without assigning it
def block_binding
  @pagy, @records = pagy(:offset, collection.new, page: 3)
  binding
end

# Run the expression and return the printed lines followed by the "=> value" line
def run(expression, context)
  io      = StringIO.new
  $stdout = io
  value   = context.eval(expression)
  io.string.lines.map(&:chomp) << "=> #{value.inspect}"
ensure
  $stdout = STDOUT
end

# Object ids change on each run
def same?(actual, documented) = actual.map { _1.gsub(/0x\h{16}/, '0x') } == documented.map { _1.gsub(/0x\h{16}/, '0x') }

outdated = []
ROOT.glob('docs/**/*.md').reject { _1.basename.to_s.start_with?('CHANGELOG') }.sort.each do |path|
  content = path.read
  updated = content.gsub(BLOCK) do |whole|
    next whole unless Regexp.last_match(1).include?('>> ')

    context = block_binding
    lines   = Regexp.last_match(1).lines.map(&:chomp)
    output  = []
    until lines.empty?
      line = lines.shift
      output << line
      next unless line.start_with?('>> ')

      documented = []
      documented << lines.shift until lines.empty? || lines.first.start_with?('>> ') || lines.first.empty?
      # Examples annotated as produced by a different paginator are not reproducible here: keep them as they are
      actual = line.match?(/#.*countless/) ? documented : run(line.delete_prefix('>> '), context)
      if same?(actual, documented)
        output.concat(documented)
      else
        outdated << "#{path.relative_path_from(ROOT)}: #{line}"
        output.concat(actual)
      end
    end
    "```ruby Console\n#{output.join("\n")}\n```"
  end
  path.write(updated) unless CHECK || updated == content
end

puts outdated
puts "#{outdated.size} outdated console outputs#{' updated' unless CHECK || outdated.empty?}"
exit(1) if CHECK && !outdated.empty?
