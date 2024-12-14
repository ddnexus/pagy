# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../files/models'
require_relative '../../gem/lib/pagy/b64'

require 'pagy/keyset_for_ui'

[Pet, PetSequel].each do |model|
  describe "Pagy Keyset with #{model}" do
    describe 'uses optional variables' do
      it 'use the :tuple_comparison' do
        pagy    = Pagy::KeysetForUI.new(model.order(:animal, :name, :id),
                                        cutoffs:          [nil, nil, "WyJjYXQiLCJFbGxhIiwxOF0"],
                                        page:             2,
                                        limit:            10,
                                        tuple_comparison: true)
        records = pagy.records
        _(records.size).must_equal 10
        _(records.first.id).must_equal 13
      end
      it 'uses :jsonify_keyset_attributes' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs:                   [nil, nil, "WzEwXQ"],
                                     page:                      2,
                                     limit:                     10,
                                     jsonify_keyset_attributes: ->(attr) { attr.values.to_json })
        _(pagy.next).must_equal(3)
        _(pagy.instance_variable_get(:@cutoff_args)).must_equal(id: 10)
      end
    end
    describe 'handles the page/cut' do
      it 'handles the page/cut for the first page' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs: nil,
                                     limit:   10)
        _(pagy.instance_variable_get(:@cut)).must_be_nil
        _(pagy.next).must_equal 2
      end
      it 'handles the page/cut for the second page' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs: [nil, nil, "WzEwXQ"],
                                     limit:   10,
                                     page:    2)
        _(pagy.instance_variable_get(:@cutoff_args)).must_equal(id: 10)
        _(pagy.records.first.id).must_equal 11
        _(pagy.next).must_equal 3
        _(pagy.cutoffs).must_equal [nil, nil, "WzEwXQ", "WzIwXQ"]
      end
      it 'handles the page/cut for the last page' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs:  [nil, nil, "WzEwXQ", "WzIwXQ", "WzMwXQ", "WzQwXQ"],
                                     limit:   10,
                                     page:    5)
        _(pagy.instance_variable_get(:@cutoff_args)).must_equal(id: 40)
        _(pagy.records.first.id).must_equal 41
        _(pagy.next).must_be_nil
      end
    end
    describe 'handles overflow' do
      it 'raises OverflowError' do
        _ do
          Pagy::KeysetForUI.new(model.order(:id),
                                cutoffs: [nil, nil, "WzEwXQ"],
                                limit:   10,
                                page:    3)
        end.must_raise Pagy::OverflowError
      end
      it 'resets overflow' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs:        [nil, nil, "WzEwXQ", "WzIwXQ"],
                                     reset_overflow: true,
                                     limit:          10,
                                     page:           4)
        _(pagy.instance_variable_get(:@cutoff_args)).must_be_nil
        _(pagy.records.first.id).must_equal 1
        _(pagy.next).must_equal 2
        _(pagy.cutoffs).must_equal [nil, nil, "WzEwXQ"]
      end
    end
    describe 'handles the jumping back' do
      it 'handles the assign_cut_args jump back to the first page' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs: [nil, nil, "WzEwXQ"], # last visited 2
                                     page:  1,
                                     limit: 10)
        _(pagy.instance_variable_get(:@cut)).must_be_nil
        _(pagy.next).must_equal 2
        _(pagy.instance_variable_get(:@cutoff_args)).must_equal(cutoff_id: 10)
      end
      it 'handles the assign_cut_args jump back to the second page' do
        pagy = Pagy::KeysetForUI.new(model.order(:id),
                                     cutoffs: [nil, nil, "WzEwXQ", "WzIwXQ"],
                                     page:    2,
                                     limit:   10)
        _(pagy.instance_variable_get(:@cutoff_args)).must_equal({ :id => 10, :cutoff_id => 20 })
        _(pagy.records.first.id).must_equal 11
        _(pagy.next).must_equal 3
        _(pagy.cutoffs).must_equal [nil, nil, "WzEwXQ", "WzIwXQ"]
      end
    end
    describe 'other requirements' do
      it 'adds the required columns to the selected values' do
        set  = model.order(:animal, :name, :id).select(:name)
        pagy = Pagy::KeysetForUI.new(set,
                                     cutoffs: nil,
                                     limit:   10)
        pagy.records
        set = pagy.instance_variable_get(:@set)
        _((model == Pet ? set.select_values : set.opts[:select]).sort).must_equal %i[animal id name]
      end
    end
    describe 'integrity of results' do
      def slurp_by_page(page: nil, records: [], &block)
        result = yield(page)
        records << result[:records]
        result[:page] ? slurp_by_page(page: result[:page], records:, &block) : records
      end

      mixed_set = if model == Pet
                    model.order(animal: :asc, birthdate: :desc, id: :asc)
                  elsif model == PetSequel
                    model.order(:animal, Sequel.desc(:birthdate), :id)
                  end
      [model.order(:id),
       model.order(:animal, :name, :id),
       mixed_set].each_with_index do |set, i|
        it "pulls all the records in set#{i} without repetions" do
          cutoffs    = nil
          pages      = slurp_by_page do |page|
            pagy    = Pagy::KeysetForUI.new(set,
                                            cutoffs:,
                                            page:,
                                            limit: 9)
            cutoffs = pagy.cutoffs
            { records: pagy.records, page: pagy.next }
          end
          collection = set.to_a
          _(collection.size).must_equal 50
          _(pages.flatten).must_equal collection
          _(collection.each_slice(9).to_a).must_equal pages
        end
      end
    end
  end
end
