# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bulma/previous_next_html'

describe 'Pagy#bulma_html_for' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :previous, :next

      def initialize(previous: nil, next_page: nil)
        @previous = previous
        @next     = next_page
      end

      # Expose private method
      public :bulma_html_for
    end
  end

  # Mock lambda to simulate a_lambda
  let(:a_lambda) do
    lambda { |page, text, classes: nil, aria_label: nil|
      %(LINK: page=#{page}, text="#{text}", classes="#{classes}", aria_label="#{aria_label}")
    }
  end

  describe 'previous link' do
    it 'renders enabled link' do
      pagy = pagy_class.new(previous: 10)
      html = pagy.bulma_html_for(:previous, a_lambda)

      _(html).must_match(%r{^<li>LINK: page=10, text="&lt;", classes="pagination-previous", aria_label="Previous"</li>$})
    end

    it 'renders disabled link' do
      pagy = pagy_class.new(previous: nil)
      html = pagy.bulma_html_for(:previous, a_lambda)

      _(html).must_match(%r{<a role="link" class="pagination-previous" disabled aria-disabled="true" aria-label="Previous">&lt;</a>})
      _(html).must_match(%r{^<li>.*</li>$})
    end
  end

  describe 'next link' do
    it 'renders enabled link' do
      pagy = pagy_class.new(next_page: 20)
      html = pagy.bulma_html_for(:next, a_lambda)

      _(html).must_match(%r{^<li>LINK: page=20, text="&gt;", classes="pagination-next", aria_label="Next"</li>$})
    end

    it 'renders disabled link' do
      pagy = pagy_class.new(next_page: nil)
      html = pagy.bulma_html_for(:next, a_lambda)

      _(html).must_match(%r{<a role="link" class="pagination-next" disabled aria-disabled="true" aria-label="Next">&gt;</a>})
      _(html).must_match(%r{^<li>.*</li>$})
    end
  end
end
