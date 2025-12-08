# frozen_string_literal: true

require 'test_helper'
require 'files/models'
require 'pagy/modules/b64'

describe "Pagy Keynav" do
  [Pet, PetSequel].each do |model|
    describe "Pagy Keynav with #{model}" do
      describe 'uses empty collection' do
        it 'sets the count to 0' do
          collection = model == Pet ? model.order(:animal, :name, :id).none : model.order(:animal, :name, :id).where(false)

          # page format: [storage_key, page, last, prior_cutoff, page_cutoff]
          pagy = Pagy::Keyset::Keynav.new(collection,
                                          page:             ['key', 1, 1, ["cat", "Ella", 18], nil],
                                          limit:            10,
                                          tuple_comparison: true)
          records = pagy.records

          _(records.size).must_equal 0
          _(pagy.instance_variable_get(:@count)).must_equal 0
          _(pagy.update).must_equal ['key', nil, 'page']

          # Assuming info_tag helper is loaded/available
          # _(pagy.info_tag).must_match 'No items found'
        end
      end

      describe 'use optional options' do
        it 'uses the :tuple_comparison' do
          pagy    = Pagy::Keyset::Keynav.new(model.order(:animal, :name, :id),
                                             page:             ['key', 2, 2, ["cat", "Ella", 18], nil],
                                             limit:            10,
                                             tuple_comparison: true)
          records = pagy.records

          _(records.size).must_equal 10
          _(records.first.id).must_equal 13
          # Update expectation: [storage_key, root, page_key, next_page, [curr_page, 1, cutoff]]
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, ["dog", "Denis", 44]]]
        end

        it 'uses :pre_serialize' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          page:                    ['key', 2, 2, [10], nil],
                                          limit:                   10,
                                          pre_serialize: ->(attr) { attr[:id] = attr[:id].to_s })

          _(pagy.next).must_equal(3)
          # serialized ID "20"
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, ["20"]]]
        end
      end

      describe 'handles the page/cut' do
        it 'handles the page/cut for the first page' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          limit: 10)

          _(pagy.instance_variable_get(:@cut)).must_be_nil
          _(pagy.next).must_equal 2
          _(pagy.update).must_equal [nil, nil, 'page', 2, [1, 1, [10]]]
        end

        it 'handles the page/cut for the second page' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          page:  ['key', 2, 2, [10]],
                                          limit: 10)

          _(pagy.records.first.id).must_equal 11
          _(pagy.next).must_equal 3
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, [20]]]
        end

        it 'handles the page/cut for the last page' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          page:  ['key', 5, 5, [40]],
                                          limit: 10, root_key: 'root')

          _(pagy.records.first.id).must_equal 41
          _(pagy.next).must_be_nil
          _(pagy.update).must_equal %w[key root page]
        end
      end

      describe 'handles the jumping back' do
        it 'handles the assign_cut_args jump back to the first page' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          page: ['key', 1, 3, nil, [10]], # last visited 2
                                          limit: 10, root_key: 'root')

          _(pagy.instance_variable_get(:@prior_cutoff)).must_be_nil
          _(pagy.next).must_equal 2
          _(pagy.update).must_equal %w[key root page]
        end

        it 'handles the assign_cut_args jump back to the second page' do
          pagy = Pagy::Keyset::Keynav.new(model.order(:id),
                                          page:  ['key', 2, 3, [20], [30]],
                                          limit: 10, root_key: 'root')

          _(pagy.records.first.id).must_equal 21
          _(pagy.next).must_equal 3
          _(pagy.instance_variable_get(:@page_cutoff)).must_equal [30]
          _(pagy.update).must_equal %w[key root page]
        end
      end

      describe 'other requirements' do
        it 'adds the required columns to the selected values' do
          set  = model.order(:animal, :name, :id).select(:name)
          pagy = Pagy::Keyset::Keynav.new(set, limit: 10)
          pagy.records
          set = pagy.instance_variable_get(:@set)

          expected = %i[animal id name]
          actual = (model == Pet ? set.select_values.map(&:to_sym) : set.opts[:select]).sort

          _(actual).must_equal expected
        end
      end

      describe 'integrity of results' do
        def slurp_by_page(page: nil, records: [], &block)
          result = yield(page)
          records << result[:records]
          result[:page] ? slurp_by_page(page: result[:page], records: records, &block) : records
        end

        mixed_set = if model == Pet
                      model.order(animal: :asc, birthdate: :desc, id: :asc)
                    elsif model == PetSequel
                      model.order(:animal, Sequel.desc(:birthdate), :id)
                    end

        [model.order(:id),
         model.order(:animal, :name, :id),
         mixed_set].each_with_index do |set, i|
          it "pulls all the records in set#{i} without repetitions" do
            cutoff_list = [nil]
            pages       = slurp_by_page do |page|
              page ||= 1
              # reconstruct page token: [key, page_num, last_known, prior_cut, current_cut]
              page_token = ['key',
                            page,
                            cutoff_list.size,
                            cutoff_list[page - 1],
                            cutoff_list[page]]

              pagy = Pagy::Keyset::Keynav.new(set,
                                              page:  page_token,
                                              limit: 9)

              cutoff_list << pagy.instance_variable_get(:@page_cutoff)
              { records: pagy.records, page: pagy.next }
            end

            collection  = set.to_a

            _(collection.size).must_equal 50
            _(pages.flatten).must_equal collection
            _(collection.each_slice(9).to_a).must_equal pages
          end
        end
      end
    end
  end
end
