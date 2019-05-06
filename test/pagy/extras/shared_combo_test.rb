# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

SimpleCov.command_name 'shared_combo' if ENV['RUN_SIMPLECOV']

# add tests for oj and pagy_id
describe Pagy::Frontend do

  let(:frontend) { TestSimpleView.new }

  describe "#pagy_links" do

    it 'should return "standard" and "trimmed" links' do
      pagy = Pagy.new(count: 100, page: 4)
      frontend.instance_eval do
        pagy_links(pagy_link_proc(pagy)).must_equal(
          {"standard"=>"<a href=\"/foo?page=--pagy.page--&items=20\"   style=\"display: none;\"></a>", "trimmed"=>"<a href=\"/foo?items=20\"   style=\"display: none;\"></a>"}
        )
      end

      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      frontend.instance_eval do
        pagy_links(pagy_link_proc(pagy)).must_equal(
          {"standard"=>"<a href=\"/foo?p=--pagy.page--&items=20\"   style=\"display: none;\"></a>", "trimmed"=>"<a href=\"/foo?items=20\"   style=\"display: none;\"></a>"}
        )
      end

      pagy = Pagy.new(count: 100, page: 4, items_param: 'i')
      frontend.instance_eval do
        pagy_links(pagy_link_proc(pagy)).must_equal(
          {"standard"=>"<a href=\"/foo?page=--pagy.page--&i=20\"   style=\"display: none;\"></a>", "trimmed"=>"<a href=\"/foo?i=20\"   style=\"display: none;\"></a>"}
        )
      end

      pagy = Pagy.new(count: 100, page: 4, page_param: 'p', items_param: 'i')
      frontend.instance_eval do
        pagy_links(pagy_link_proc(pagy)).must_equal(
          {"standard"=>"<a href=\"/foo?p=--pagy.page--&i=20\"   style=\"display: none;\"></a>", "trimmed"=>"<a href=\"/foo?i=20\"   style=\"display: none;\"></a>"}
        )
      end


    end

  end

  describe '#pagy_items_selector_js' do

    it 'renders items selector with trim' do
      @pagy = Pagy.new count: 1000, page: 3
      html = frontend.pagy_items_selector_js(@pagy, 'test-id')

      html.must_equal \
        "<span id=\"test-id\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> items per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",\"test-id\",41,{\"standard\":\"<a href=\\\"/foo?page=--pagy.page--&items=--pagy.items--\\\"   style=\\\"display: none;\\\"></a>\",\"trimmed\":\"<a href=\\\"/foo?items=--pagy.items--\\\"   style=\\\"display: none;\\\"></a>\"}]</script>"
    end

  end


end

