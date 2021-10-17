# frozen_string_literal: true

require 'json'

# If you use the RubyMine coverage command to run the rake default (test),
# RubyMine will run the coverage with its tools thus this task will be skipped.
desc 'Display SimpleCov coverage summary'
task :coverage_summary do
  unless ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']
    last_run = JSON.parse(File.read('coverage/.last_run.json'))
    line     = last_run['result']['line']
    branch   = last_run['result']['branch']
    message  = "\n>>> Coverage -> line: #{line}% -> branch: #{branch}%\n"
    message << ">>> Missing #{(100.0 - line).round(2)}% of line coverage!\n" if line < 100.0
    message << ">>> Missing #{(100.0 - branch).round(2)}% of branch coverage!\n" if branch < 100.0
    message << ">>> Run the task again with HTML_REPORTS=true for a line-by-line HTML report @ coverage/index.html\n" \
               if (line < 100 || branch < 100) && !ENV['HTML_REPORTS']
    puts "#{message}\n"
  end
end
