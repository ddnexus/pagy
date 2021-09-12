# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/overflow'

describe 'pagy/extras/overflow' do
  let(:vars) {{ page: 100, count: 103, items: 10, size: [3, 2, 2, 3] }}
  let(:countless_vars) {{ page: 100, items: 10 }}
  before do
    @pagy = Pagy.new(vars)
    @pagy_countless = Pagy::Countless.new(countless_vars)
    @pagy_countless.finalize(0)
  end

  describe "variables" do
    it 'has vars defaults' do
      _(Pagy::VARS[:overflow]).must_equal :empty_page  # default for countless
    end
  end

  describe "#overflow?" do
    it 'must be overflow?'  do
      _(@pagy).must_be :overflow?
      _(@pagy_countless).must_be :overflow?
    end
    it 'is not overflow?' do
      _(Pagy.new(vars.merge(page:2))).wont_be :overflow?
    end
  end

  describe '#initialize' do
    it 'works in :last_page mode' do
      pagy = Pagy.new(vars.merge(overflow: :last_page))
      _(pagy).must_be_instance_of Pagy
      _(pagy.page).must_equal pagy.last
      _(pagy.vars[:page]).must_equal 100
      _(pagy.offset).must_equal 100
      _(pagy.items).must_equal 10
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.prev).must_equal 10
    end
    it 'raises OverflowError in :exception mode' do
      _(proc { Pagy.new(vars.merge(overflow: :exception)) }).must_raise Pagy::OverflowError
      _(proc { Pagy::Countless.new(countless_vars.merge(overflow: :exception)).finalize(0) }).must_raise Pagy::OverflowError
    end
    it 'works in :empty_page mode' do
      pagy = Pagy.new(vars.merge(overflow: :empty_page))
      _(pagy.page).must_equal 100
      _(pagy.offset).must_equal 0
      _(pagy.items).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_equal pagy.last
    end
    it 'raises Pagy::VariableError' do
      _(proc { Pagy.new(vars.merge(overflow: :unknown)) }).must_raise Pagy::VariableError
      _(proc { Pagy::Countless.new(countless_vars.merge(overflow: :unknown)).finalize(0) }).must_raise Pagy::VariableError
    end
  end

  describe "#series singleton for :empty_page mode" do
    it 'computes series for last page' do
      pagy = Pagy.new(vars.merge(overflow: :empty_page))
      series = pagy.series
      _(series).must_equal [1, 2, 3, :gap, 9, 10, 11]
      _(pagy.page).must_equal 100
    end
    it 'computes empty series' do
      series = @pagy_countless.series
      _(series).must_equal []
      _(@pagy_countless.page).must_equal 100
    end
  end
end
