# frozen_string_literal: true

require 'rake/testtask'
require_relative '../test/e2e/helpers/e2e_app'

# Helper to define tasks
def define_test_task(name, pattern)
  Rake::TestTask.new(name) do |t|
    t.libs    = %w[gem/lib test]
    t.pattern = pattern
    t.warning = true
  end
end

# Task for all tests
define_test_task(:test, 'test/**/*_test.rb')

namespace :test do
  # Task for Unit tests only
  define_test_task(:unit, 'test/unit/**/*_test.rb')

  # Task for E2E tests only
  define_test_task(:e2e, 'test/e2e/**/*_test.rb')

  namespace :e2e do
    E2eApp::APPS.each_key do |app|
      define_test_task(app, "test/e2e/#{app}_test.rb")
    end

    desc 'Download external assets for E2E tests'
    task :download_assets do
      require 'fileutils'
      require 'open-uri'

      assets_path = Pagy::ROOT.join('../test/e2e/assets')
      puts "Asset directory: #{assets_path}"
      FileUtils.mkdir_p(assets_path)

      assets = {
        'tailwind.js'       => 'https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio',
        'bootstrap.min.css' => 'https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css',
        'bulma.min.css'     => 'https://cdn.jsdelivr.net/npm/bulma@1/css/bulma.min.css'
      }

      assets.each do |filename, url|
        puts "Downloading #{url} to #{filename}"
        content = URI.parse(url).open.read
        File.write(File.join(assets_path, filename), content)
      end
    end
  end
end
