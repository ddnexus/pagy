# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bootstrap/previous_next_html'

describe 'Pagy#bootstrap_html_for' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :previous, :next

      def initialize(previous: nil, next_page: nil)
        @previous = previous
        @next     = next_page
      end

      # Expose private method
      public :bootstrap_html_for
    end
  end

  # Mock lambda to simulate a_lambda result
  let(:a_lambda) do
    lambda { |page, text, classes: nil, aria_label: nil|
      %(LINK: page=#{page}, text="#{text}", classes="#{classes}", aria_label="#{aria_label}")
    }
  end

  describe 'previous link' do
    it 'renders enabled link' do
      pagy = pagy_class.new(previous: 10)
      html = pagy.bootstrap_html_for(:previous, a_lambda)

      # Expected: <li class="page-item previous">LINK...</li>
      _(html).must_match(%r{^<li class="page-item previous">LINK: page=10, text="&lt;", classes="page-link", aria_label="Previous"</li>$})
    end

    it 'renders disabled link' do
      pagy = pagy_class.new(previous: nil)
      html = pagy.bootstrap_html_for(:previous, a_lambda)

      # Expected: <li class="page-item previous disabled"><a ...>...</a></li>
      _(html).must_match(%r{^<li class="page-item previous disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="Previous">&lt;</a></li>$})
    end
  end

  describe 'next link' do
    it 'renders enabled link' do
      pagy = pagy_class.new(next_page: 20)
      html = pagy.bootstrap_html_for(:next, a_lambda)

      _(html).must_match(%r{^<li class="page-item next">LINK: page=20, text="&gt;", classes="page-link", aria_label="Next"</li>$})
    end

    it 'renders disabled link' do
      pagy = pagy_class.new(next_page: nil)
      html = pagy.bootstrap_html_for(:next, a_lambda)

      _(html).must_match(%r{^<li class="page-item next disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="Next">&gt;</a></li>$})
    end
  end
end
