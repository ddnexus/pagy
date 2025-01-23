# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/console'

module PagyConsole
  include Pagy::Console
end

describe 'pagy/console' do
  describe 'Pagy::Console' do
    it 'includes Pagy::Backend and Pagy::Frontend' do
      assert_operator(PagyConsole, :<, Pagy::Backend)
      assert_operator(PagyConsole, :<, Pagy::Frontend)
    end
  end
end
