# frozen_string_literal: true

require 'test_helper'
require 'pagy/modules/searcher'

describe Pagy::Searcher do
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
    end
  end

  let(:results) { mock_results_class.new }

  it 'returns results directly when no chaining (calling is empty)' do
    # pagy_search_args: [model, term, options, block] (size 4) -> calling is empty
    args = [nil, nil, nil, nil]

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal results
  end

  it 'applies chained method to results (calling is present)' do
    # pagy_search_args: [..., :records]
    # This triggers the `results.send(*calling)` branch
    args = [nil, nil, nil, nil, :records]

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal [:records_called]
  end

  it 'applies chained method with arguments to results' do
    # pagy_search_args: [..., :scope_with_arg, 123]
    args = [nil, nil, nil, nil, :scope_with_arg, 123]

    _pagy, res = searcher.wrap(args, options) do
      [:pagy_obj, results]
    end

    _(res).must_equal [:scope_called, 123]
  end
end
