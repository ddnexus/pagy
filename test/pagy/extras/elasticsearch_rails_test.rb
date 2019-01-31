require_relative '../../test_helper'
require 'pagy/extras/elasticsearch_rails'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  let(:backend) { TestController.new }

  class ElasticsearchRails
    class Results
      def initialize(params); @params = params; end
      def total; 1000; end
      def offset(*); self; end
      def limit(*); 25; end
      def page
        @params[:page] || 1
      end
    end
  end

  describe "#pagy_elasticsearch_rails" do

    before do
      @collection = ElasticsearchRails::Results.new(backend.params)
    end

    it 'paginates with defaults' do
      pagy, _items = backend.send(:pagy_elasticsearch_rails, @collection)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 20 # Pagy default
      pagy.page.must_equal backend.params[:page]
    end

    it 'paginates with vars' do
      pagy, _items = backend.send(:pagy_elasticsearch_rails, @collection, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 20 # Pagy default
      pagy.vars[:link_extra].must_equal 'X'
    end

  end

  describe "#pagy_elasticsearch_rails_get_vars" do

    before do
      @collection = ElasticsearchRails::Results.new(backend.params)
    end

    it 'gets defaults' do
      vars = {}
      merged = backend.send :pagy_elasticsearch_rails_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged[:count].must_equal 1000
      merged[:items].must_be_nil
      merged[:page].must_equal 3
    end

    it 'gets vars' do
      vars   = { items: 25, link_extra: 'X' }
      merged = backend.send :pagy_elasticsearch_rails_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :link_extra
      merged[:count].must_equal 1000
      merged[:items].must_equal 25
      merged[:link_extra].must_equal 'X'
    end

  end

end
