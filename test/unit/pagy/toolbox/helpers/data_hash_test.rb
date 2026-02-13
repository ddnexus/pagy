# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/data_hash'

describe 'Pagy#data_hash' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :count, :page, :limit, :last, :in, :from, :to, :previous, :next, :options

      def initialize(vars = {})
        @options  = vars[:options]  || {}
        @count    = vars[:count]    || 100
        @page     = vars[:page]     || 3
        @limit    = vars[:limit]    || 20
        @last     = vars[:last]     || 5
        @in       = vars[:in]       || 20
        @from     = vars[:from]     || 41
        @to       = vars[:to]       || 60
        @previous = vars[:previous] || 2
        @next     = vars[:next]     || 4
      end

      # Mock Linkable#compose_page_url behavior
      def compose_page_url(page, **_opts)
        "https://example.com/foo?page=#{page || 1}"
      end

      # Mock calendar? check
      def calendar?
        @options[:calendar]
      end

      public :data_hash
    end
  end

  let(:pagy) { pagy_class.new }

  it 'returns default data hash' do
    data = pagy.data_hash

    _(data[:count]).must_equal 100
    _(data[:page]).must_equal 3
    _(data[:previous]).must_equal 2
    _(data[:next]).must_equal 4

    # Check URLs based on the mock compose_page_url
    base = 'https://example.com/foo?page='
    _(data[:url_template]).must_equal "#{base}#{Pagy::PAGE_TOKEN}"
    _(data[:page_url]).must_equal     "#{base}3"
    _(data[:current_url]).must_equal  "#{base}3"
    _(data[:first_url]).must_equal    "#{base}1"
    _(data[:previous_url]).must_equal "#{base}2"
    _(data[:next_url]).must_equal     "#{base}4"
    _(data[:last_url]).must_equal     "#{base}5"
  end

  it 'filters count and limit for calendar' do
    pagy.options[:calendar] = true
    data = pagy.data_hash

    _(data.keys).wont_include :count
    _(data.keys).wont_include :limit
    _(data[:page]).must_equal 3
  end

  it 'respects passed data_keys' do
    keys = %i[page limit]
    data = pagy.data_hash(data_keys: keys)

    _(data.keys.sort).must_equal %i[limit page]
  end

  it 'raises OptionError for unknown keys' do
    _ { pagy.data_hash(data_keys: [:unknown_key]) }.must_raise Pagy::OptionError
  end

  it 'omits nil values (compacts)' do
    # Set all nullable attributes to nil to trigger the 'else' branches
    pagy.previous = nil
    pagy.next     = nil
    pagy.last     = nil

    data = pagy.data_hash

    _(data.keys).wont_include :previous
    _(data.keys).wont_include :previous_url
    _(data.keys).wont_include :next
    _(data.keys).wont_include :next_url
    _(data.keys).wont_include :last
    _(data.keys).wont_include :last_url
  end
end
