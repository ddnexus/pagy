# frozen_string_literal: true

require 'oj'
require_relative '../../test_helper'
require 'pagy/extras/shared'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/shared_oj' do
  let(:app) { MockApp.new(params: {}) }

  describe '#pagy_json_attr' do
    it 'should use oj' do
      _(app.pagy_json_attr(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch
      _(app.pagy_json_attr(Pagy.new(count: 10, trim_extra: true), :test_function, 'some-string', 123, true)).must_rematch
    end
  end

  describe '#pagy_marked_link' do
    it 'should return only the "standard" link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch
    end
  end
end
