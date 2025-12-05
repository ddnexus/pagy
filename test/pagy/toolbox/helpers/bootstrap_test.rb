# frozen_string_literal: true

require 'test_helper'
require 'helpers/nav_tests'

describe "Bootstrap nav test" do
  # 1. Include the Helper Logic
  include NavTests

  # 2. Define the style for this file (No CONSTANTS!)
  let(:style) { :bootstrap }

  # 3. Include the Shared Specs (generates the tests using 'style')
  include NavTests::Shared
end
