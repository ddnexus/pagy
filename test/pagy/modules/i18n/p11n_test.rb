# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n do
  it 'has autoloads defined' do
    expected_constants = []
    Pagy::ROOT.join('gem/lib/pagy/modules/i18n/p11n').glob('*.rb').each do |file|
      filename = file.basename('.rb').to_s
      expected_constants << filename.split('_').map(&:capitalize).join.to_sym
    end
    expected_constants.each do |const|
      # Verify the constant is recognized by the module (autoloaded or loaded)
      _(Pagy::I18n::P11n.const_defined?(const)).must_equal true
    end
  end
end
