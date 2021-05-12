# frozen_string_literal: true

desc 'Rematch all the tests with their new values'
task :rematch_all do
  FileList.new('test/**/*_test.rb.yml').each { |f| File.delete(f) }
  Rake::Task['test'].invoke
end
