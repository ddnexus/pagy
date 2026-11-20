# frozen_string_literal: true

require 'thor'

class Test < Thor
  def self.exit_on_failure? = true

  desc 'all', 'Test Rubocop + Src lint + API + Coverage + E2E'
  def all
    exit 1 unless system('rubocop')
    exit 1 unless system('bun run src-lint')
    invoke 'test:api:coverage'
    invoke 'test:e2e:apps'
  end

  protected

  def run_tests(files, env = {})
    cmd = "ruby -Ilib:test -e 'ARGV.each{|f| require \"./\#{f}\"}' #{files.join(' ')}"
    exit(1) unless system(ENV.to_h.merge(env), cmd)
  end
end
