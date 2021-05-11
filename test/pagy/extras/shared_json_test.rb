# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'

describe 'pagy/extras/shared_json' do
  let(:view) { MockView.new('http://example.com:3000/foo?') }

  describe '#pagy_json_attr' do
    it 'should use json' do
      _(view.pagy_json_attr(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_equal \
        "data-pagy-json=\"[&quot;test_function&quot;,&quot;some-string&quot;,123,true]\""
    end
  end

  describe '#pagy_marked_link' do
    it 'should return only the "standard" link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal("<a href=\"/foo?page=__pagy_page__\"   style=\"display: none;\"></a>")
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal("<a href=\"/foo?p=__pagy_page__\"   style=\"display: none;\"></a>")
    end
  end
end
