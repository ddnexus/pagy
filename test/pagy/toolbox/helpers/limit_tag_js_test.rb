# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/limit_tag_js'

describe 'Pagy#limit_tag_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :limit, :from, :options

      def initialize(limit: 20, from: 1, options: {})
        @limit   = limit
        @from    = from
        @options = options
      end

      # Mock compose_page_url to return a predictable string
      def compose_page_url(page, limit: nil, **_opts)
        "URL(#{page},#{limit})"
      end

      # Mock data_pagy_attribute to verify arguments
      def data_pagy_attribute(*args)
        %(data-pagy="#{args.join('|')}")
      end

      public :limit_tag_js
    end
  end

  let(:options) { { client_max_limit: 100 } }
  let(:pagy) { pagy_class.new(limit: 20, from: 1, options: options) }

  it 'raises OptionError if client_max_limit is missing' do
    pagy.options[:client_max_limit] = nil
    _ { pagy.limit_tag_js }.must_raise Pagy::OptionError
  end

  it 'renders the limit tag' do
    html = pagy.limit_tag_js

    # Check container
    _(html).must_match(/<span class="pagy limit-tag-js"/)

    # Check data attribute (mocked)
    # args: :ltj, @from (1), url_token
    # url_token: compose_page_url(PAGE_TOKEN, limit: LIMIT_TOKEN) -> URL(P ,L )
    _(html).must_match(/data-pagy="ltj\|1\|URL\(P ,L \)\|P \|L "/)

    # Check input
    _(html).must_match(/<input name="limit" type="number" min="1" max="100" value="20"/)
    _(html).must_match(/style="padding: 0; text-align: center; width: 3rem;"/)

    # Check label structure (default en locale)
    # "Show [input] items per page"
    _(html).must_match(%r{<label>Show <input.*> items per page</label>})
  end

  it 'accepts optional id' do
    html = pagy.limit_tag_js(id: 'test-id')
    _(html).must_match(/<span id="test-id"/)
  end

  it 'accepts custom item_name' do
    html = pagy.limit_tag_js(item_name: 'widgets')
    _(html).must_match(/widgets per page/)
  end

  it 'accepts client_max_limit override' do
    html = pagy.limit_tag_js(client_max_limit: 50)
    _(html).must_match(/max="50"/)
  end
end
