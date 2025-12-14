# frozen_string_literal: true

require 'test_helper'
require 'fileutils'

# Mock P11n class for testing custom dictionaries
module Pagy::I18n::P11n # rubocop:disable Style/ClassAndModuleChildren
  module TestRule
    def self.plural_for(count)
      case count
      when 0 then 'zero'
      when 1 then 'one'
      else 'other'
      end
    end
  end
end

describe Pagy::I18n do
  let(:i18n) { Pagy::I18n }

  describe 'configuration' do
    after do
      # Reset thread local
      i18n.locale = nil
    end

    it 'defaults to en' do
      _(i18n.locale).must_equal 'en'
    end

    it 'stores locale per thread' do
      i18n.locale = 'es'
      _(i18n.locale).must_equal 'es'

      Thread.new do
        _(i18n.locale).must_equal 'en'
        i18n.locale = 'it'
        _(i18n.locale).must_equal 'it'
      end.join

      _(i18n.locale).must_equal 'es'
    end

    it 'has default pathnames' do
      _(i18n.pathnames).must_include Pagy::ROOT.join('locales')
    end
  end

  describe 'translation logic' do
    let(:tmp_dir) { Dir.mktmpdir }
    let(:yaml_path) { File.join(tmp_dir, 'test.yml') }

    before do
      # Create a custom locale file
      content = <<~YAML
        test:
          pagy:
            p11n: 'TestRule'
            simple: 'Simple'
            nested:
              key: 'Nested'
            plural:
              zero: 'Zero'
              one: 'One'
              other: 'Other'
            vars: "Hello %{name}!"
      YAML
      File.write(yaml_path, content)

      # Modify I18n state
      @original_pathnames = i18n.pathnames.dup
      @original_locales   = i18n.locales.dup

      i18n.pathnames << Pathname.new(tmp_dir)
      i18n.locale = 'test'
    end

    after do
      # Restore I18n state
      i18n.instance_variable_set(:@pathnames, @original_pathnames)
      i18n.instance_variable_set(:@locales, @original_locales)
      i18n.locale = nil
      FileUtils.rm_rf(tmp_dir)
    end

    it 'loads and flattens keys' do
      _(i18n.translate('pagy.simple')).must_equal 'Simple'
      _(i18n.translate('pagy.nested.key')).must_equal 'Nested'
    end

    it 'interpolates variables' do
      _(i18n.translate('pagy.vars', name: 'World')).must_equal 'Hello World!'
      # Keeps missing keys intact
      _(i18n.translate('pagy.vars', other: 'Ignored')).must_equal 'Hello %{name}!'
    end

    it 'handles pluralization via P11n class' do
      _(i18n.translate('pagy.plural', count: 0)).must_equal 'Zero'
      _(i18n.translate('pagy.plural', count: 1)).must_equal 'One'
      _(i18n.translate('pagy.plural', count: 10)).must_equal 'Other'
    end

    it 'handles missing keys' do
      msg = i18n.translate('pagy.missing')
      _(msg).must_equal '[translation missing: "pagy.missing"]'
    end

    it 'raises error for missing locale file' do
      i18n.locale = 'unknown'
      _ { i18n.translate('foo') }.must_raise Errno::ENOENT
    end

    it 'caches loaded locales' do
      # First access triggers load
      _(i18n.locales['test']).must_be_nil
      i18n.translate('pagy.simple')

      # Now it should be cached
      entry = i18n.locales['test']
      _(entry).must_be_kind_of Array
      _(entry[0]).must_be_kind_of Hash # the dictionary
      _(entry[1]).must_equal Pagy::I18n::P11n::TestRule # the rule class

      # Modify cache to prove it's used
      entry[0]['pagy.simple'] = 'Cached'
      _(i18n.translate('pagy.simple')).must_equal 'Cached'
    end
  end

  describe 'default locale integration' do
    # Assuming the gem comes with 'en' locale and 'OneOther' rule
    # We need to make sure P11n::OneOther is defined or loadable.
    # Since we don't have control over p11n.rb here, we just check if it works
    # if the environment is set up correctly (which it is via require 'pagy').

    it 'translates using built-in en locale' do
      i18n.locale = 'en'
      # Verify a known key from standard dictionary
      _(i18n.translate('pagy.aria_label.next')).must_equal 'Next'
      _(i18n.translate('pagy.item_name', count: 1)).must_equal 'item'
      _(i18n.translate('pagy.item_name', count: 2)).must_equal 'items'
    end
  end
end
