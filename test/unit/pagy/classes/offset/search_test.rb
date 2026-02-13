# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Search Specs' do
  describe 'Arguments' do
    it 'collects method calls via method_missing' do
      args = Pagy::Search::Arguments.new
      args.foo
      args.bar(1, 2)

      # Array#push appends arguments
      # .foo -> method_missing(:foo) -> push(:foo)
      # .bar(1,2) -> method_missing(:bar, 1, 2) -> push(:bar, 1, 2)
      _(args).must_equal [:foo, :bar, 1, 2]
    end

    it 'responds to missing methods' do
      args = Pagy::Search::Arguments.new
      _(args.respond_to?(:any_method)).must_equal true
    end
  end

  describe 'pagy_search method' do
    let(:search_class) do
      Class.new do
        include Pagy::Search
      end
    end

    it 'returns Arguments object populated with arguments' do
      obj = search_class.new
      block = proc {}
      args = obj.pagy_search('term', a: 1, &block)

      _(args).must_be_kind_of Pagy::Search::Arguments
      _(args).must_equal [obj, 'term', { a: 1 }, block]
    end

    it 'allows chaining' do
      obj = search_class.new
      # chain calls: pagy_search(...).page(2).limit(10)
      args = obj.pagy_search('term').page(2).limit(10)

      _(args).must_equal [obj, 'term', {}, nil, :page, 2, :limit, 10]
    end
  end
end

describe 'Pagy::SearchBase Specs' do
  it 'inherits from Offset' do
    _(Pagy::SearchBase.superclass).must_equal Pagy::Offset
  end

  it 'defines identity method' do
    pagy = Pagy::SearchBase.new(count: 10)
    # search? and offset? are protected/inherited
    _(pagy.send(:search?)).must_equal true
    _(pagy.send(:offset?)).must_equal true
  end

  it 'has default options' do
    _(Pagy::SearchBase::DEFAULT[:search_method]).must_equal :search
  end
end

describe 'Pagy::ElasticsearchRails Specs' do
  it 'inherits from SearchBase' do
    _(Pagy::ElasticsearchRails.superclass).must_equal Pagy::SearchBase
  end
end

describe 'Pagy::Meilisearch Specs' do
  it 'inherits from SearchBase' do
    _(Pagy::Meilisearch.superclass).must_equal Pagy::SearchBase
  end

  it 'overrides default options' do
    _(Pagy::Meilisearch::DEFAULT[:search_method]).must_equal :ms_search
  end
end

describe 'Pagy::Searchkick Specs' do
  it 'inherits from SearchBase' do
    _(Pagy::Searchkick.superclass).must_equal Pagy::SearchBase
  end
end
