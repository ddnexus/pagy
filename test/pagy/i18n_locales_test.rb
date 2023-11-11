# frozen_string_literal: true

require_relative '../test_helper'

describe 'pagy/locales' do
  let(:rules) { Pagy::I18n::P11n::RULE.keys }
  let(:counts) do
    {
      arabic:             %w[zero one two few many other],
      east_slavic:        %w[one few many other],
      one_other:          %w[one other],
      one_two_other:      %w[one two other],
      one_upto_two_other: %w[one other],
      other:              %w[other],
      polish:             %w[one few many other],
      west_slavic:        %w[one few other]
    }
  end

  # locale files loop
  Pagy.root.join('locales').each_child do |f|
    next unless f.extname == '.yml'

    message = "locale file #{f}"
    locale  = f.basename.to_s[0..-5]
    comment = f.readlines.first.to_s.strip
    rule    = comment.to_s.split[1][1..-1].to_s.to_sym

    it 'includes a comment with the pluralization rule and the i18n.rb reference' do
      _(rules).must_include rule, message
      _(comment).must_match 'https://github.com/ddnexus/pagy/blob/master/lib/pagy/i18n.rb', message
    end
    it 'defines and matches the locale pluralization rule' do
      _(Pagy::I18n::P11n::LOCALE[locale]).must_equal Pagy::I18n::P11n::RULE[rule], message
    end
    it 'pluralizes item_name according to the rule' do
      hash      = YAML.safe_load(f.read)
      item_name = hash[locale]['pagy']['item_name']
      case item_name
      when String
        _(rule).must_equal :other
      when Hash
        _(item_name.keys - counts[rule]).must_be_empty
      else
        raise StandardError, "item_name must be Hash or String"
      end
    end
  end
end
