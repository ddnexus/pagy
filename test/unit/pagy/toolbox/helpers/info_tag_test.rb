# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/info_tag'

describe 'Pagy#info_tag' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :count, :page, :last, :in, :from, :to

      def initialize(vars = {})
        @count = vars[:count]
        @page  = vars[:page]
        @last  = vars[:last]
        @in    = vars[:in]
        @from  = vars[:from]
        @to    = vars[:to]
      end

      public :info_tag
    end
  end

  it 'renders no_count message when count is nil' do
    # key: pagy.info_tag.no_count -> "Page %{page} of %{pages}"
    pagy = pagy_class.new(count: nil, page: 3, last: 10)

    html = pagy.info_tag
    _(html).must_equal '<span class="pagy info">Page 3 of 10</span>'
  end

  it 'renders no_items message when count is 0' do
    # key: pagy.info_tag.no_items -> "No %{item_name} found"
    # item_name (count: 0) -> "items"
    pagy = pagy_class.new(count: 0)

    html = pagy.info_tag
    _(html).must_equal '<span class="pagy info">No items found</span>'
  end

  it 'renders single_page message when showing all items' do
    # key: pagy.info_tag.single_page -> "Displaying %{count} %{item_name}"
    # item_name (count: 5) -> "items"
    pagy = pagy_class.new(count: 5, in: 5)

    html = pagy.info_tag
    _(html).must_equal '<span class="pagy info">Displaying 5 items</span>'
  end

  it 'renders multiple_pages message when paginated' do
    # key: pagy.info_tag.multiple_pages -> "Displaying %{item_name} %{from}-%{to} of %{count} in total"
    # item_name (count: 100) -> "items"
    pagy = pagy_class.new(count: 100, in: 20, from: 1, to: 20)

    html = pagy.info_tag
    _(html).must_equal '<span class="pagy info">Displaying items 1-20 of 100 in total</span>'
  end

  it 'accepts custom item_name' do
    # "No products found"
    pagy = pagy_class.new(count: 0)

    html = pagy.info_tag(item_name: 'products')
    _(html).must_equal '<span class="pagy info">No products found</span>'
  end

  it 'accepts optional id' do
    pagy = pagy_class.new(count: 0)

    html = pagy.info_tag(id: 'my-info')
    _(html).must_match(/id="my-info"/)
  end
end
