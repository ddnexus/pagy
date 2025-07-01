# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../files/models'
require_relative '../../../../gem/lib/pagy/modules/b64'

describe "Pagy Keyset" do
  [Pet, PetSequel].each do |model|
    describe "Pagy Keyset with #{model}" do
      describe 'initialize' do
        it 'raises TypeError on wrong set type' do
          _ { Pagy::Keyset.new(10) }.must_raise TypeError
        end
        it 'raises ArgumentError without arguments' do
          err = assert_raises(ArgumentError) { Pagy::Keyset.new }
          assert_match(/wrong number of arguments/, err.message)
        end
        it 'raises ArgumentError without order' do
          err = assert_raises(Pagy::InternalError) { Pagy::Keyset.new(model.select(:id)) }
          assert_match(/the set must be ordered/, err.message)
        end
        it 'is an instance of Pagy::Keyset' do
          _(Pagy::Keyset.new(model.order(:id))).must_be_kind_of Pagy::Keyset
        end
      end
      describe 'uses optional options' do
        it 'use the :tuple_comparison' do
          pagy    = Pagy::Keyset.new(model.order(:animal, :name, :id),
                                     page:             "WyJjYXQiLCJFbGxhIiwxOF0",
                                     limit:            10,
                                     tuple_comparison: true)
          records = pagy.records

          _(records.size).must_equal 10
          _(records.first.id).must_equal 13
        end
        it 'use the :pre_serialize' do
          pagy    = Pagy::Keyset.new(model.order(:animal, :name, :id),
                                     page:          "WyJjYXQiLCJFbGxhIiwxOF0",
                                     limit:         10,
                                     pre_serialize: ->(attr) { attr[:name] = attr[:name].to_s })
          records = pagy.records

          _(pagy.next).must_equal "WyJkb2ciLCJEZW5pcyIsNDRd"
          _(records.size).must_equal 10
          _(records.first.id).must_equal 13
        end
      end
      describe 'extract_keyset' do
        it 'extracts the keyset from the set order (single column)' do
          pagy = Pagy::Keyset.new(model.order(:id))

          _(pagy.instance_variable_get(:@keyset)).must_equal({ :id => :asc })
          set  = model == Pet ? model.order(id: :desc) : model.order(Sequel.desc(:id))
          pagy = Pagy::Keyset.new(set)

          _(pagy.instance_variable_get(:@keyset)).must_equal({ :id => :desc })
        end
        it 'extracts the keyset from the set order (multiple columns)' do
          set  = if model == Pet
                   model.order(animal: :desc, id: :asc)
                 else
                   model.order(Sequel.desc(:animal), Sequel.asc(:id))
                 end
          pagy = Pagy::Keyset.new(set)

          _(pagy.instance_variable_get(:@keyset)).must_equal({ animal: :desc, :id => :asc })
        end
        if model == PetSequel
          it 'raises TypeError for unknown order type' do
            _ { Pagy::Keyset.new(model.order(id: :desc)) }.must_raise TypeError
          end
          it 'skips unrestricted primary keys' do
            model.unrestrict_primary_key
            p = Pagy::Keyset.new(model.order(:id),
                                 page:  "WzEwXQ",
                                 limit: 10)

            _(p.next).must_equal "WzIwXQ" # trigger typecast
            _(model.restrict_primary_key?).must_equal false
            model.restrict_primary_key
            p = Pagy::Keyset.new(model.order(:id),
                                 page:  "WzEwXQ",
                                 limit: 10)

            _(p.next).must_equal "WzIwXQ" # trigger typecast
            _(model.restrict_primary_key?).must_equal true
          end
        end
      end
      describe 'handles the page/cut' do
        it 'handles the page/cut for the first page' do
          pagy = Pagy::Keyset.new(model.order(:id), limit: 10)

          _(pagy.instance_variable_get(:@cut)).must_be_nil
          _(pagy.next).must_equal "WzEwXQ"
        end
        it 'handles the page/cut for the second page' do
          pagy = Pagy::Keyset.new(model.order(:id), limit: 10, page: "WzEwXQ")

          _(pagy.records.first.id).must_equal 11
          _(pagy.next).must_equal "WzIwXQ"
        end
        it 'handles the page/cut for the last page' do
          pagy = Pagy::Keyset.new(model.order(:id), limit: 10, page: "WzQwXQ")

          _(pagy.records.first.id).must_equal 41
          _(pagy.next).must_be_nil
        end
      end
      describe 'other requirements' do
        it 'adds the required columns to the selected values' do
          set  = model.order(:animal, :name, :id).select(:name)
          pagy = Pagy::Keyset.new(set, limit: 10)
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
            pages      = slurp_by_page do |page|
              pagy = Pagy::Keyset.new(set, page:, limit: 9)
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
end
