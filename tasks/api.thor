# frozen_string_literal: true

require 'json'

class Test < Thor
  class Api < Test
    desc 'current', 'Test current API'
    def current
      puts "\nTesting the CURRENT API..."

      files = Dir.glob('test/unit/**/*_test.rb')
                 .push('test/api/current_test.rb')

      run_tests(files, 'COMMAND_NAME' => 'CURRENT_API')
    end

    desc 'next', 'Test next API'
    def next
      puts "\nTesting the NEXT API..."

      files = Dir.glob('test/unit/**/*_test.rb')
                 .reject { _1.include?('version_test.rb') }  # PAGY::VERSION in files must be CURRENT
                 .push('test/api/next_test.rb')

      run_tests(files, 'COMMAND_NAME' => 'NEXT_API', 'PAGY_NEXT' => 'true')
    end

    desc 'all', 'Test current and next API'
    def all
      invoke 'current'
      invoke 'next'
    end

    desc 'coverage', 'Test API coverage'
    def coverage
      require 'simplecov'

      ENV['COVERAGE'] = 'true' # set COVERAGE for all (see run_tests)
      invoke 'all'

      puts "\nMerging coverage..."
      SimpleCov.collate Dir['coverage/*/.resultset.json'] do
        enable_coverage :branch
        minimum_coverage line: 100, branch: 100
        merge_timeout(10) unless ENV['CI'] # fast dev env iterations
      end
    rescue SystemExit => e
      puts "Report: file://#{SimpleCov.coverage_path}/index.html" if e.status == 2
      raise
    end
  end
end
