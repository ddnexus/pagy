# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Offset::Countish Specs' do
  let(:pagy_class) { Pagy::Offset::Countish }

  it 'composes page param with count' do
    pagy = pagy_class.new(count: 100)
    param = pagy.send(:compose_page_param, 2)

    _(param).must_be_kind_of Pagy::EscapedValue
    _(param).must_equal '2+100'
  end

  it 'composes page param with default page 1' do
    pagy = pagy_class.new(count: 50)
    param = pagy.send(:compose_page_param, nil)

    _(param).must_equal '1+50'
  end

  it 'composes page param with epoch' do
    pagy = pagy_class.new(count: 100, epoch: 999)
    param = pagy.send(:compose_page_param, 3)

    _(param).must_equal '3+100+999'
  end
end
