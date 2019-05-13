# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/headers'
require 'pagy/countless'

describe Pagy::Backend do

  describe "#pagy_headers" do

    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end

    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Current-Page"=>3, "Page-Items"=>20, "Total-Pages"=>50, "Total-Count"=>1000})
    end

    it 'returns custom headers hash' do
      pagy, _records = @controller.send(:pagy, @collection, headers:{items:'Per-Page', count: 'Total', pages:false})
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Per-Page"=>20, "Total"=>1000})
    end

    it 'returns the countless headers hash' do
      pagy, _records = @controller.send(:pagy_countless, @collection)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\"", "Current-Page"=>3, "Page-Items"=>20})
    end

    it 'omit prev on first page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 1)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Current-Page"=>1, "Page-Items"=>20, "Total-Pages"=>50, "Total-Count"=>1000})
    end

    it 'omit next on last page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 50)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=49>; rel=\"prev\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Current-Page"=>50, "Page-Items"=>20, "Total-Pages"=>50, "Total-Count"=>1000})
    end

  end

  describe "#pagy_headers_merge" do

    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end

    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      @controller.send(:pagy_headers_merge, pagy)
      @controller.send(:response).headers.must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Current-Page"=>3, "Page-Items"=>20, "Total-Pages"=>50, "Total-Count"=>1000})
    end

  end

end
