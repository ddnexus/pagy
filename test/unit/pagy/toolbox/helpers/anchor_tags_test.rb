# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/anchor_tags'

describe 'Pagy anchor_tags' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :previous, :next

      # Renamed 'next' argument to 'next_page' to avoid keyword collision
      def initialize(previous: nil, next_page: nil)
        @previous = previous
        @next     = next_page
      end

      # Mock a_lambda to return a predictable string for testing
      def a_lambda(**_opts)
        lambda do |page, text, aria_label: nil|
          %(LINK: page=#{page} text="#{text}" label="#{aria_label}")
        end
      end

      public :previous_tag, :next_tag
    end
  end

  let(:pagy) { pagy_class.new }

  describe '#previous_tag' do
    it 'returns disabled tag when previous is nil' do
      pagy.previous = nil
      tag = pagy.previous_tag

      _(tag).must_include 'aria-disabled="true"'
      _(tag).must_include 'role="link"'
      _(tag).must_include '&lt;'
      _(tag).must_include 'aria-label="Previous"'
    end

    it 'returns enabled tag when previous is set' do
      pagy.previous = 10
      tag = pagy.previous_tag

      _(tag).must_equal 'LINK: page=10 text="&lt;" label="Previous"'
    end

    it 'accepts custom text and aria_label' do
      pagy.previous = 10
      tag = pagy.previous_tag(text: "Back", aria_label: "Go Back")

      _(tag).must_equal 'LINK: page=10 text="Back" label="Go Back"'
    end

    it 'accepts a custom lambda' do
      pagy.previous = 10
      custom_a = ->(page, text, aria_label:) { "CUSTOM: #{page}, #{text}" } # rubocop:disable Lint/UnusedBlockArgument
      tag = pagy.previous_tag(custom_a)

      _(tag).must_equal 'CUSTOM: 10, &lt;'
    end
  end

  describe '#next_tag' do
    it 'returns disabled tag when next is nil' do
      pagy.next = nil
      tag = pagy.next_tag

      _(tag).must_include 'aria-disabled="true"'
      _(tag).must_include '&gt;'
      _(tag).must_include 'aria-label="Next"'
    end

    it 'returns enabled tag when next is set' do
      pagy.next = 20
      tag = pagy.next_tag

      _(tag).must_equal 'LINK: page=20 text="&gt;" label="Next"'
    end

    it 'accepts custom text and aria_label' do
      pagy.next = 20
      tag = pagy.next_tag(text: "Forward", aria_label: "Go Forward")

      _(tag).must_equal 'LINK: page=20 text="Forward" label="Go Forward"'
    end
  end
end
