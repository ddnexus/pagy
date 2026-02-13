# frozen_string_literal: true

require 'unit/test_helper'
require 'yaml'

describe 'locales' do
  # Define the expected keys for each pluralization rule
  let(:counts) do
    { 'Arabic'          => %w[zero one two few many other],
      'EastSlavic'      => %w[one few many other],
      'OneOther'        => %w[one other],
      'OneUptoTwoOther' => %w[one other],
      'Other'           => %w[other],
      'Polish'          => %w[one few many other],
      'WestSlavic'      => %w[one few other] }
  end

  # Iterate over every YAML file in the locales directory
  Pagy::ROOT.join('locales').glob('*.yml').each do |file|
    locale  = file.basename('.yml').to_s
    content = file.read
    # Header comment check (first line)
    comment = content.lines.first.to_s.strip
    # Parse YAML
    data    = YAML.safe_load(content)
    pagy    = data[locale]['pagy']
    p11n    = pagy.delete('p11n')

    describe "locale file #{file.basename}" do
      it "includes a header comment referencing the documentation" do
        # Checks if the first line link matches the documentation URL
        _(comment).must_match 'https://ddnexus.github.io/pagy/resources/i18n'
      end

      it "implements the #{p11n} pluralization rules consistently" do
        count_keys = counts[p11n]

        # Validation for 'Other' rule (singular/invariant)
        if p11n == 'Other'
          # Expect simple Strings for invariant locales
          _(pagy['item_name']).must_be_instance_of String
          _(pagy['aria_label']['nav']).must_be_instance_of String

          # Validation for pluralized rules
        else
          # Check item_name structure
          _(pagy['item_name']).must_be_kind_of Hash
          _(pagy['item_name'].keys.sort).must_equal count_keys.sort,
                                                    "pagy.item_name keys should match #{p11n} keys: #{count_keys}"

          # Check aria_label.nav structure
          _(pagy['aria_label']['nav']).must_be_kind_of Hash
          _(pagy['aria_label']['nav'].keys.sort).must_equal count_keys.sort,
                                                            "pagy.aria_label.nav keys should match #{p11n} keys: #{count_keys}"
        end
      end
    end
  end
end
