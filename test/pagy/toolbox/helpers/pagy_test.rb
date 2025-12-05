# frozen_string_literal: true

require 'test_helper'
require 'helpers/nav_tests'

describe 'Pagy nav test' do
  # 1. Setup shared logic
  include NavTests

  # 2. Define style as nil (Default Pagy)
  let(:style) { nil }

  # 3. Include the standard suite
  include NavTests::Shared

  # 4. Custom tests specific to default Pagy

  # Helper for the loop below
  def self.tests_for(method, page_finalize, **others)
    page_finalize.each do |page, finalize|
      it "renders the #{method} for page #{page}" do
        request        = Pagy::Request.new(request: MockApp.new.request)
        pagy           = Pagy::Offset.new(count: 1000, page: page, request:)
        pagy_countless = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, finalize)

        _(pagy.send(method)).must_rematch :r1
        _(pagy_countless.send(method)).must_rematch :r2
        _(pagy.send(method, **others)).must_rematch :r3
        _(pagy_countless.send(method, **others)).must_rematch :r4
      end
    end
  end

  describe 'previous_tag' do
    tests_for(:previous_tag, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'PREV', aria_label: 'My previous page')
  end

  describe 'next_tag' do
    tests_for(:next_tag, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'NEXT', aria_label: 'My next page')
  end
end
