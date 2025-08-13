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

    message       = "locale file #{f}"
    locale        = f.basename.to_s[0..-5]                 # e.g. de
    comment       = f.readlines.first.to_s.strip           # e.g. :one_other pluralization (see https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb)
    rule          = comment.to_s.split[1][1..].to_s.to_sym # e.g. one_other
    language_yml  = YAML.safe_load(f.read)

    it 'includes a comment with the pluralization rule and the i18n.rb reference' do
      _(rules).must_include rule, message
      _(comment).must_match 'https://github.com/ddnexus/pagy/blob/master/gem/lib/pagy/i18n.rb', message
    end
    it 'defines and matches the locale pluralization rule' do
      _(Pagy::I18n::P11n::LOCALE[locale]).must_equal Pagy::I18n::P11n::RULE[rule], message
    end
    it 'pluralizes item_name according to the rule' do
      item_name = language_yml[locale]['pagy']['item_name']
      case item_name
      when String

        _(rule).must_equal :other
      when Hash

        _(item_name.keys - counts[rule]).must_be_empty
      else
        raise StandardError, "item_name must be Hash or String"
      end
    end
    it "ensures #{locale}.yml has the correct aria_label,nav and item_name keys per the declared (#{rule}) rule" do
      skip if %w[sw].include?(locale) # sw.yml does not have the requisite keys yet

      pluralizations = counts[rule]

      if rule == :other
        # For the :other rules, we should not have any keys under the
        # ['pagy']['item_name'] and ['pagy']['aria_label']['nav'] hierarchies.
        # We should just have a String.
        _(language_yml[locale]['pagy']['item_name']).must_be_instance_of(String)
        _(language_yml[locale]['pagy']['aria_label']['nav']).must_be_instance_of(String)
      else
        _(language_yml[locale]['pagy']['item_name'].keys.sort).must_equal pluralizations.sort, "In #{message} - check that ['pagy']['item_name'] does not have keys inconsistent with #{rule}"
        _(language_yml[locale]['pagy']['aria_label']['nav'].keys.sort).must_equal pluralizations.sort, "In #{message} - check that ['pagy']['aria_label']['nav'] does not have keys inconsistent with #{rule}"
      end
    end
  end
end
