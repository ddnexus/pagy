# frozen_string_literal: true

require_relative '../../../test_helper'

describe '#info_tag' do
  it 'renders without i18n key' do
    _(Pagy::Offset.new(count: 0).info_tag).must_rematch :info_0
    _(Pagy::Offset.new(count: 1).info_tag).must_rematch :info_1
    _(Pagy::Offset.new(count: 13).info_tag).must_rematch :info_13
    _(Pagy::Offset.new(count: 100, page: 3).info_tag).must_rematch :info_100
  end
  it 'overrides the item_name and set id' do
    _(Pagy::Offset.new(count: 0).info_tag(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_0
    _(Pagy::Offset.new(count: 1).info_tag(id: 'pagy-info', item_name: 'Widget')).must_rematch :info_1
    _(Pagy::Offset.new(count: 13).info_tag(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_13
    _(Pagy::Offset.new(count: 100, page: 3).info_tag(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_100
  end
end
