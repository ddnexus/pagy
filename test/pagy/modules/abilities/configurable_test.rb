# frozen_string_literal: true

require_relative '../../../test_helper'
require 'fileutils'
require 'pathname'

describe ".sync_javascript" do
  let(:destination) { Dir.mktmpdir }
  let(:all_files) { %w[pagy.mjs pagy.js pagy.js.map pagy.min.js] }

  after do
    FileUtils.rm_rf(destination)
  end

  it "copies all default javascript targets" do
    Pagy.sync_javascript(destination)
    all_files.each do |file|
      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied"
    end
  end

  it "copies specified javascript targets" do
    targets = %w[pagy.js pagy.min.js]
    Pagy.sync_javascript(destination, *targets)

    %w[pagy.js pagy.min.js].each do |file|
      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied"
    end

    %w[pagy.mjs pagy.js.map].each do |file|
      _(File.exist?(File.join(destination, file))).must_equal false, "Did NOT expect #{file} to be copied"
    end
  end

  it "raises an error if source file does not exist" do
    _ { Pagy.sync_javascript(destination, 'nonexistent') }.must_raise Errno::ENOENT
  end

  it "overwrites existing files" do
    file = 'pagy.js'
    FileUtils.touch(File.join(destination, file))
    original_mtime = File.mtime(File.join(destination, file))
    sleep 0.1

    Pagy.sync_javascript(destination, 'pagy.js')
    _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied"
    _(original_mtime < File.mtime(File.join(destination, file))).must_equal true, "File should have been overwritten"
  end

  it "removes files not specified when copying a subset of targets" do
    keep_files   = %w[pagy.js pagy.min.js]
    remove_files = all_files - keep_files

    all_files.each { |file| FileUtils.cp(Pagy::ROOT.join('javascript', file), destination) }
    Pagy.sync_javascript(destination, 'pagy.js', 'pagy.min.js')

    keep_files.each do |file|
      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to remain"
    end
    remove_files.each do |file|
      _(File.exist?(File.join(destination, file))).must_equal false, "Expected #{file} to be removed"
    end
  end

  it "handles paths with Pathname objects" do
    destination_path = Pathname.new(destination)
    Pagy.sync_javascript(destination_path)
    all_files.each do |file|
      _(File.exist?(destination_path.join(file))).must_equal true, "Expected #{file} to be copied"
    end
  end
end
