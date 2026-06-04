# frozen_string_literal: true

require 'unit/test_helper'
require 'fileutils'
require 'pathname'
require 'i18n'
require 'pagy/toolbox/helpers/info_tag' # Required for the integration test

describe 'Pagy::Configurable Specs' do
  describe 'sync_javascript' do
    let(:destination) { Dir.mktmpdir }
    let(:all_files) { %w[pagy.mjs pagy.js pagy.min.js] }

    after do
      FileUtils.rm_rf(destination)
    end

    it "copies specified javascript targets" do
      targets = %w[pagy.js pagy.min.js]
      Pagy.sync(:javascript, destination, *targets)

      targets.each do |file|
        _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied"
      end

      %w[pagy.mjs].each do |file|
        _(File.exist?(File.join(destination, file))).must_equal false, "Did NOT expect #{file} to be copied"
      end
    end

    it "raises an error if source file does not exist" do
      _ { Pagy.sync(:javascript, destination, 'nonexistent') }.must_raise Pagy::InternalError
    end

    it "overwrites existing files" do
      file = 'pagy.js'
      FileUtils.touch(File.join(destination, file))
      original_mtime = File.mtime(File.join(destination, file))
      sleep 0.1

      Pagy.sync(:javascript, destination, 'pagy.js')

      _(File.exist?(File.join(destination, file))).must_equal true, "Expected #{file} to be copied"
      _(original_mtime < File.mtime(File.join(destination, file))).must_equal true, "File should have been overwritten"
    end

    it "handles paths with Pathname objects" do
      destination_path = Pathname.new(destination)
      Pagy.sync(:javascript, destination_path, *all_files)

      all_files.each do |file|
        _(File.exist?(destination_path.join(file))).must_equal true, "Expected #{file} to be copied"
      end
    end
  end

  describe 'dev_tools' do
    let(:js_content) { Pagy::ROOT.join('javascripts/wand.js').read }
    let(:css_content) { Pagy::ROOT.join('stylesheets/pagy.css').read }

    it 'generates the wand tag with default scale' do
      generated_html = Pagy.dev_tools # scale: 1 is default

      # Default Integer 1 is coerced to 1.0 by to_f (parseFloat("1.0") === 1 client-side)
      _(generated_html).must_match %r{<script id="pagy-wand" data-scale="1\.0">\s*#{Regexp.escape(js_content)}\s*</script>}m
      # Check style tag structure and content using regex
      _(generated_html).must_match %r{<style id="pagy-wand-default">\s*#{Regexp.escape(css_content)}\s*</style>}m
    end

    it 'generates the wand tag with custom fractional scale' do
      generated_html = Pagy.dev_tools(wand_scale: 2.5)

      # Fractional scale is preserved (to_f, not to_i)
      _(generated_html).must_match %r{<script id="pagy-wand" data-scale="2\.5">\s*#{Regexp.escape(js_content)}\s*</script>}m
      _(generated_html).must_match %r{<style id="pagy-wand-default">\s*#{Regexp.escape(css_content)}\s*</style>}m
    end

    it 'neutralizes a non-numeric wand_scale (no attribute injection)' do
      generated_html = Pagy.dev_tools(wand_scale: %(1"></script><script>alert(1)</script>))

      # to_f stops at the first non-numeric char: the payload collapses to 1.0
      _(generated_html).must_match(/<script id="pagy-wand" data-scale="1\.0">/)
      _(generated_html).wont_include '<script>alert(1)</script>'
    end
  end

  describe 'translate_with_the_slower_i18n_gem!' do
    # Store the original implementation to restore it later
    before do
      @original_pagy_i18n     = Pagy::I18n
      @original_gem_load_path = I18n.load_path.dup # Save external gem state too

      Pagy.translate_with_the_slower_i18n_gem!
    end

    # Clean up immediately after these tests finish
    after do
      Pagy.send(:remove_const, :I18n)
      Pagy.send(:const_set, :I18n, @original_pagy_i18n)
      I18n.load_path = @original_gem_load_path
    end

    it 'does not conflict with the I18n gem namespace' do
      # Ensures ::I18n is still usable directly
      I18n.backend.store_translations(:en, { test: 'Success' })
      _(I18n.t('test')).must_equal 'Success'
    end

    it 'is the actual gem module' do
      _(Pagy::I18n).must_equal I18n
      _(Pagy::I18n::VERSION).must_equal I18n::VERSION
    end

    it 'pluralizes using the gem' do
      _(Pagy::I18n.translate('pagy.aria_label.previous')).must_equal "Previous"
      _(Pagy::I18n.translate('pagy.item_name', count: 0)).must_equal 'items'
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal  'item'
      _(Pagy::I18n.translate('pagy.item_name', count: 10)).must_equal 'items'
    end

    it 'handles missing paths' do
      _(Pagy::I18n.translate('pagy.not_here')).must_equal 'Translation missing: en.pagy.not_here'
    end

    it 'integration: renders info_tag using the gem' do
      # This confirms the switch affects downstream helpers
      expect(Pagy::Offset.new(count: 0).info_tag).to_hold
      expect(Pagy::Offset.new(count: 1).info_tag).to_hold
      expect(Pagy::Offset.new(count: 13).info_tag).to_hold
      expect(Pagy::Offset.new(count: 100, page: 3).info_tag).to_hold
    end
  end
end
