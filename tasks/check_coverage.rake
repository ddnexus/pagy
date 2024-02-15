# frozen_string_literal: true

require 'json'

desc 'Display coverage summary. Fail if not 100%'
task :check_coverage do
  last_run = JSON.parse(File.read(File.expand_path('../coverage/.last_run.json', __dir__)))
  line     = last_run['result']['line']
  branch   = last_run['result']['branch']
  message  = "\n>>> Coverage -> line: #{line}% -> branch: #{branch}%\n"
  message << ">>> Missing #{(100.0 - line).round(2)}% of line coverage!\n" if line < 100
  message << ">>> Missing #{(100.0 - branch).round(2)}% of branch coverage!\n" if branch < 100
  if line < 100 || branch < 100
    message << ">>> Run the task again with COVERAGE_REPORT=true for a line-by-line HTML report @ coverage/index.html\n" \
    unless ENV['COVERAGE_REPORT']
    warn message
    exit 1
  else
    puts message
  end
end
