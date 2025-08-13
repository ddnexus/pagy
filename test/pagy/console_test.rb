# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/console'

module PagyConsole
  include Pagy::Console

  # we are not in the console so we need module_function
  module_function :pagy_extras
end

describe 'pagy/console' do
  describe 'Pagy::Console' do
    it 'defines default :url' do
      _(Pagy::DEFAULT[:url]).must_equal 'http://www.example.com/subdir'
    end
    it 'includes Pagy::Backend and Pagy::Frontend' do
      assert_operator(PagyConsole, :<, Pagy::Backend)
      assert_operator(PagyConsole, :<, Pagy::Frontend)
    end
    it 'requires extras' do
      _ { PagyConsole.pagy_extras :array, :pagy }.must_output "Required extras: :array, :pagy\n"
      _(Pagy::Backend.method_defined?(:pagy_array))
      _(Pagy::Frontend.method_defined?(:pagy_nav_js))
    end
  end
end
