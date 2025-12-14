# frozen_string_literal: true

require 'minitest/autorun'

class Pagy
  class TestCase < Minitest::Spec
    def teardown
      Pagy::I18n.locale = 'en' # reset to default
      super
    end
  end
end
Minitest::Spec.register_spec_type(/.*/, Pagy::TestCase)
