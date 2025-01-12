# frozen_string_literal: true

require_relative '../test_helper'
require 'yaml'

describe 'pagy/locales' do
  let(:rules) { Pagy::I18n::P11n::RULE.keys }
  let(:counts) do
    { arabic:             %w[zero one two few many other],
      east_slavic:        %w[one few many other],
      one_other:          %w[one other],
      one_two_other:      %w[one two other],
      one_upto_two_other: %w[one other],
      other:              %w[other],
      polish:             %w[one few many other],
      west_slavic:        %w[one few other] }
  end

  # locale files loop
  Pagy::ROOT.join('locales').each_child do |f|
    next unless f.extname == '.yml'

    message = "locale file #{f}"
    locale  = f.basename.to_s[0..-5] # e.g. de
    comment = f.readlines.first.to_s.strip # e.g. :one_other pluralization (see https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb)
    rule    = comment.to_s.split[1][1..].to_s.to_sym # e.g. one_other
    pagy    = YAML.safe_load(f.read)[locale]['pagy']

    it "includes a comment with the #{rule} pluralization rule and the i18n.rb reference" do
      _(rules).must_include rule, message
      _(comment).must_match 'https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb', message
    end
    it "defines and matches the #{rule} pluralization rule for the #{locale} locale" do
      _(Pagy::I18n::P11n::LOCALE[locale]).must_equal Pagy::I18n::P11n::RULE[rule], message
    end
    it "pluralizes the 'item_name' according to the #{rule} rule" do
      item_name = pagy['item_name']
      case item_name
      when String
        _(rule).must_equal :other
      when Hash
        _(item_name.keys - counts[rule]).must_be_empty
      else
        raise StandardError, "the item_name must be a Hash or String"
      end
    end
    it "ensures #{locale}.yml implements the #{rule} pluralization rule" do
      # ta.yml and sw.yml do not have the requisite keys yet
      skip(message) if %w[ta sw].include?(locale)

      count_keys = counts[rule]
      if rule == :other
        # With the :other rules, pagy.item_name and pagy.aria_label.nav entries must be strings.
        _(pagy['item_name']).must_be_instance_of(String)
        _(pagy['aria_label']['nav']).must_be_instance_of(String)
      else
        _(pagy['item_name'].keys.sort).must_equal count_keys.sort,
          "In #{message} - pagy.item_name should be consistent with #{rule}" # rubocop:disable Layout/ArgumentAlignment
        _(pagy['aria_label']['nav'].keys.sort).must_equal count_keys.sort,
          "In #{message} - pagy.aria_label.nav should be consistent with #{rule}"  # rubocop:disable Layout/ArgumentAlignment
      end
    end
  end
end
