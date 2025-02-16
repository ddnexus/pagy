# frozen_string_literal: true

require_relative '../test_helper'
require 'fileutils'
require 'pathname'

describe ".sync_javascript_source" do
  let(:destination) { Dir.mktmpdir }

  after do
    FileUtils.rm_rf(destination)
  end

  it "copies all default javascript files" do
    Pagy.sync_javascript_source(destination)

    expected_files = %w[pagy.mjs pagy.js pagy.js.map pagy.min.js]
    expected_files.each do |file|
      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied" # Correct
    end
  end

  it "copies specified javascript files" do
    files = %w[pagy.js pagy.min.js]
    Pagy.sync_javascript_source(destination, *files)

    files.each do |file|
      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied" # Correct
    end

    %w[pagy.mjs pagy.js.map].each do |file|
      _(File.exist?(File.join(destination, file))).must_equal false, "Did NOT expect #{file} to be copied" # Correct
    end
  end

  it "raises an error if source file does not exist" do
    _ { Pagy.sync_javascript_source(destination, "nonexistent_file.js") }.must_raise Errno::ENOENT # Correct (this one was already correct)
  end

  it "overwrites existing files" do
    file = "pagy.js"
    FileUtils.touch(File.join(destination, file))
    original_mtime = File.mtime(File.join(destination, file))
    sleep 0.1 # Small delay (still not ideal, but keeping it as requested)

    Pagy.sync_javascript_source(destination, file)

    _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied" # Correct
    _(original_mtime < File.mtime(File.join(destination, file))).must_equal true, "File should have been overwritten" # Correct
  end
end
