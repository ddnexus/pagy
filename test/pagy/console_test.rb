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
      assert PagyConsole <= Pagy::Backend
      assert PagyConsole <= Pagy::Frontend
    end
    it 'requires extras' do
      PagyConsole.pagy_extras :array, :navs
      _(Pagy::Backend.method_defined?(:pagy_array))
      _(Pagy::Frontend.method_defined?(:pagy_nav_js))
    end
  end
end
