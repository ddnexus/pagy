# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'

describe 'pagy/extras/shared_json' do
  let(:view) { MockView.new('http://example.com:3000/foo?') }

  describe '#pagy_json_attr' do
    it 'should use json' do
      _(view.pagy_json_attr(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch
    end
  end

  describe '#pagy_marked_link' do
    it 'should return only the "standard" link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
    end
  end
end
