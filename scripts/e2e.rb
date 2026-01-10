#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'scripty'
require 'open3'

# Manage Cypress e2e tests
# Usage:
#   ruby scripts/e2e.rb open APP [PORT]          # Open cypress for the APP (on PORT)
#   ruby scripts/e2e.rb test [APP] [PORT] [-a]   # Run cypress tests for the APP (on PORT) or all apps (parallel)
#   ruby scripts/e2e.rb rebuild                  # Rebuild snapshots
module E2e
  include Scripty

  APPS = %w[demo repro rails calendar keynav].freeze
  ROOT = Scripty::ROOT
  E2E  = ROOT.join('e2e')

  module_function

  def run
    command = ARGV.shift
    case command
    when 'open'    then open_app
    when 'test'    then test_app
    when 'rebuild' then rebuild
    else
      puts 'Usage: scripts/cy.rb [open|test|rebuild] [options]'
      exit 1
    end
  end

  def open_app
    app  = ARGV[0]
    port = ARGV[1] || '8080'
    abort 'Error: app argument missing' unless app

    Dir.chdir(E2E) do
      # NOTE: No quiet mode for pagy in open
      cmd = format(%(bun run start-test "CY_TEST=true bundle exec #{ROOT}/gem/bin/pagy #{app} -p #{port}" ),
                   "http://0.0.0.0:#{port}") + 'cypress open'
      exec cmd
    end
  end

  def test_app
    args       = ARGV.dup
    all_output = args.delete('-a')
    app        = args[0]
    port       = args[1] || '8080'

    Dir.chdir(E2E) do
      if app
        puts ">>> Output for #{app}:"
        output, status = run_test_cmd(app, port)
        puts filter_output(output, all_output)
        exit 1 unless status.success?
      else
        run_parallel_tests(port.to_i, all_output)
      end
    end
  end

  def rebuild
    port = 8080
    Dir.chdir(E2E) do
      puts 'Reconciling the test snapshots...'
      File.write('snapshots.js', "\n")

      APPS.each do |app|
        port += 1
        # Rebuild runs sequentially and streams output
        success = system_test_cmd(app, port)
        exit 1 unless success
      end
    end
  end

  # Helpers

  def run_test_cmd(app, port)
    cmd = test_command_string(app, port)
    Open3.capture2e(cmd)
  end

  def system_test_cmd(app, port)
    cmd = test_command_string(app, port)
    system(cmd)
  end

  def test_command_string(app, port)
    %(NODE_NO_WARNINGS=1 FORCE_COLOR=1 ) +
      %(bun run start-test "CY_TEST=true bundle exec #{ROOT}/gem/bin/pagy #{app} -p #{port} -q > /dev/null" ) +
      %("http://0.0.0.0:#{port}" ) +
      %("cypress run --quiet --config baseUrl=http://127.0.0.1:#{port} --spec cypress/e2e/#{app}.cy.ts")
  end

  def run_parallel_tests(start_port, all_output)
    threads = []
    APPS.each_with_index do |app, idx|
      port = start_port + idx + 1
      threads << Thread.new do
        output, status = run_test_cmd(app, port)
        { app:, output:, status: }
      end
    end

    spinner = (1..40).map { |i| '·' * i }
    failed  = false
    count   = 0

    while threads.any?
      print "\r#{spinner[count % spinner.size]}\e[K"
      threads.delete_if do |t|
        next if t.alive?

        res = t.value
        failed = true unless res[:status].success?

        print "\r\e[K"
        print '·' * 40
        puts filter_output(res[:output], all_output)
        count = -1
        true
      end
      count += 1
      sleep 0.5
    end
    print "\r\e[K"

    exit 1 if failed
  end

  def filter_output(output, all_output)
    return output if all_output

    filters = ['starting server using command',
               'is responding with HTTP status code',
               'running tests using command',
               'DevTools listening on']
    output.lines.grep_v(Regexp.union(filters)).reject { |l| l.strip.empty? }.join
  end
end

E2e.run if __FILE__ == $PROGRAM_NAME
