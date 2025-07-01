# frozen_string_literal: true

require_relative '../../../test_helper'

require 'yaml'

describe 'pagy/locales' do
  let(:counts) do
    { 'Arabic'          => %w[zero one two few many other],
      'EastSlavic'      => %w[one few many other],
      'OneOther'        => %w[one other],
      'OneUptoTwoOther' => %w[one other],
      'Other'           => %w[other],
      'Polish'          => %w[one few many other],
      'WestSlavic'      => %w[one few other] }
  end

  # locale files loop
  Pagy::ROOT.join('locales').each_child do |f|
    next unless f.extname == '.yml'

    message = "locale file #{f}"
    locale  = f.basename.to_s[0..-5] # e.g. de
    comment = f.readlines.first.to_s.strip # e.g. :one_other pluralization (see https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb)
    pagy    = YAML.safe_load(f.read)[locale]['pagy']
    p11n    = pagy.delete('p11n')

    it "includes a comment with the #{p11n} pluralization and the i18n.rb reference" do
      _(comment).must_match 'https://ddnexus.github.io/pagy/resources/i18n', message
    end
    it "pluralizes the 'item_name' according to the #{p11n} rules" do
      item_name = pagy['item_name']
      case item_name
      when String

        _(p11n).must_equal 'Other'
      when Hash

        _(item_name.keys - counts[p11n]).must_be_empty
      else
        raise StandardError, "the item_name must be a Hash or String"
      end
    end
    it "ensures #{locale}.yml implements the #{p11n} pluralization" do
      count_keys = counts[p11n]
      if p11n == 'Other'
        # With the :other plurals, pagy.item_name and pagy.aria_label.nav entries must be strings.
        _(pagy['item_name']).must_be_instance_of(String)
        _(pagy['aria_label']['nav']).must_be_instance_of(String)
      else
        _(pagy['item_name'].keys.sort).must_equal count_keys.sort,
          "In #{message} - pagy.item_name should be consistent with #{p11n}" # rubocop:disable Layout/ArgumentAlignment
        _(pagy['aria_label']['nav'].keys.sort).must_equal count_keys.sort,
          "In #{message} - pagy.aria_label.nav should be consistent with #{p11n}"  # rubocop:disable Layout/ArgumentAlignment
      end
    end
  end
end
