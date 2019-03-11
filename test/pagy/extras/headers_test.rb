# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/headers'
require 'pagy/countless'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  describe "#pagy_headers" do

    before do
      @controller = TestController.new
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Items"=>20, "Per-Page"=>20, "Count"=>1000, "Total"=>1000})
    end

    it 'returns the countless headers hash' do
      pagy, _records = @controller.send(:pagy_countless, @collection)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\"", "Items"=>20, "Per-Page"=>20})
    end

    it 'omit prev on first page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 1)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Items"=>20, "Per-Page"=>20, "Count"=>1000, "Total"=>1000})
    end

    it 'omit next on last page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 50)
      @controller.send(:pagy_headers, pagy).must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=49>; rel=\"prev\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Items"=>20, "Per-Page"=>20, "Count"=>1000, "Total"=>1000})
    end

  end

  describe "#pagy_headers_merge" do

    before do
      @controller = TestController.new
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      @controller.send(:pagy_headers_merge, pagy)
      @controller.send(:response).headers.must_equal({"Link"=>"<https://example.com:8080/foo?page=1>; rel=\"first\", <https://example.com:8080/foo?page=2>; rel=\"prev\", <https://example.com:8080/foo?page=4>; rel=\"next\", <https://example.com:8080/foo?page=50>; rel=\"last\"", "Items"=>20, "Per-Page"=>20, "Count"=>1000, "Total"=>1000})
    end

  end



end
