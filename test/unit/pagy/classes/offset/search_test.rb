# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Search Specs' do
  describe 'Arguments' do
    it 'records the chained calls via method_missing' do
      block = proc {}
      args  = Pagy::Search::Arguments.new(:model, ['term'], {}, nil)
      chain = args.foo.bar(1, 2, key: 3, &block)

      _(chain).must_be_same_as args
      _(args.to_ary).must_equal [:model, ['term'], {}, nil, [[:foo, [], {}, nil], [:bar, [1, 2], { key: 3 }, block]]]
    end

    it 'records the methods of Array and Enumerable' do
      args = Pagy::Search::Arguments.new(:model, [], {}, nil)
      args.filter(status: 'published').reject(archived: true).sort(:title)

      _(args.to_ary.last).must_equal [[:filter, [], { status: 'published' }, nil],
                                      [:reject, [], { archived: true }, nil],
                                      [:sort, [:title], {}, nil]]
    end

    it 'responds to missing methods except the conversion methods' do
      args = Pagy::Search::Arguments.new
      _(args.respond_to?(:any_method)).must_equal true
      _(args.respond_to?(:to_str)).must_equal false
      _(args.respond_to?(:to_ary)).must_equal true
      _(proc { args.to_str }).must_raise NoMethodError
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
      _(args.to_ary).must_equal [obj, ['term'], { a: 1 }, block, []]
    end

    it 'allows chaining' do
      obj = search_class.new
      # chain calls: pagy_search(...).page(2).limit(10)
      args = obj.pagy_search('term').page(2).limit(10)

      _(args.to_ary).must_equal [obj, ['term'], {}, nil, [[:page, [2], {}, nil], [:limit, [10], {}, nil]]]
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
