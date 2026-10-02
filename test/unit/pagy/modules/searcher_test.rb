# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/modules/searcher'
require 'pagy/classes/offset/search'

describe 'Pagy::Searcher Specs' do
  let(:searcher) { Pagy::Searcher }

  # Mock Request object
  let(:mock_request_class) do
    Struct.new(:page, :limit) do
      def resolve_page = page
      def resolve_limit = limit
    end
  end

  let(:request) { mock_request_class.new(1, 10) }
  let(:options) { { request: request } }

  # Mock Results object that supports chained calls
  let(:mock_results_class) do
    Class.new do
      def records
        [:records_called]
      end

      def scope_with_arg(arg)
        [:scope_called, arg]
      end

      def scope_with_kwargs(arg, key:)
        [:kwargs_called, arg, key, yield]
      end
    end
  end

  let(:results) { mock_results_class.new }

  it 'returns results directly when no chaining (calls is empty)' do
    args = Pagy::Search::Arguments.new(nil, nil, nil, nil)

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal results
  end

  it 'applies chained method to results (calls is present)' do
    args = Pagy::Search::Arguments.new(nil, nil, nil, nil).records

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal [:records_called]
  end

  it 'applies chained method with arguments to results' do
    args = Pagy::Search::Arguments.new(nil, nil, nil, nil).scope_with_arg(123)

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal [:scope_called, 123]
  end

  it 'applies multiple chained methods in order, with keyword arguments and block' do
    args = Pagy::Search::Arguments.new(nil, nil, nil, nil).records.first

    _pagy, res = searcher.wrap(args, options) { [:pagy_obj, results] }

    _(res).must_equal :records_called

    args = Pagy::Search::Arguments.new(nil, nil, nil, nil).scope_with_kwargs(1, key: 2) { 3 }

    _pagy, res = searcher.wrap(args, options) { [:pagy_obj, results] }

    _(res).must_equal [:kwargs_called, 1, 2, 3]
  end
end
