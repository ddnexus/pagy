# frozen_string_literal: true

require 'test_helper'
require 'pagy/modules/b64'

describe "Pagy::Keyset::Keynav" do
  [Pet, PetSequel].each do |model|
    describe "with #{model}" do
      let(:ordered_set) { model.order(:id) }

      describe 'initialization' do
        it 'handles empty collection' do
          # Keyset requires the collection to be ordered, even if empty.
          # Both AR and Sequel support this syntax.
          empty_set = model.order(:id).where(id: nil)

          # page format: [storage_key, page, last, prior_cutoff, page_cutoff]
          pagy = Pagy::Keyset::Keynav.new(empty_set,
                                          page:             ['key', 1, 1, nil, nil],
                                          limit:            10)

          records = pagy.records
          _(records.size).must_equal 0
          _(pagy.instance_variable_get(:@count)).must_equal 0
          _(pagy.update).must_equal ['key', nil, 'page']
        end
      end

      describe 'optional options' do
        it 'uses :tuple_comparison' do
          set = model.order(:animal, :name, :id)
          pagy = Pagy::Keyset::Keynav.new(set,
                                          page:             ['key', 2, 2, ["cat", "Ella", 18], nil],
                                          limit:            10,
                                          tuple_comparison: true)
          records = pagy.records

          _(records.size).must_equal 10
          _(records.first.id).must_equal 13

          # Check update structure: [storage_key, root, page_key, next_page, [curr_page, 1, cutoff]]
          update = pagy.update
          _(update[3]).must_equal 3 # next page
          _(update[4][2]).must_equal ["dog", "Denis", 44] # cutoff
        end

        it 'uses :pre_serialize' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:          ['key', 2, 2, [10], nil],
                                          limit:         10,
                                          pre_serialize: ->(attr) { attr[:id] = attr[:id].to_s })

          _(pagy.next).must_equal 3
          # Serialized ID in update
          _(pagy.update.last.last).must_equal ["20"]
        end
      end

      describe 'page navigation' do
        it 'handles first page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set, limit: 10)

          _(pagy.next).must_equal 2
          # Update for page 1->2
          _(pagy.update).must_equal [nil, nil, 'page', 2, [1, 1, [10]]]
        end

        it 'handles middle page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 2, [10]],
                                          limit: 10)

          _(pagy.records.first.id).must_equal 11
          _(pagy.next).must_equal 3
          # Update for page 2->3
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, [20]]]
        end

        it 'handles last page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 5, 5, [40]],
                                          limit: 10, root_key: 'root')

          _(pagy.records.first.id).must_equal 41
          _(pagy.next).must_be_nil
          _(pagy.update).must_equal %w[key root page]
        end
      end

      describe 'jumping back' do
        it 'jumps back to first page' do
          # Current page 1, but we have history (last 3)
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page: ['key', 1, 3, nil, [10]],
                                          limit: 10, root_key: 'root')

          _(pagy.next).must_equal 2
          _(pagy.update).must_equal %w[key root page]
        end

        it 'jumps back to middle page' do
          # Jump to page 2 (between 20 and 30)
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 3, [20], [30]],
                                          limit: 10, root_key: 'root')

          _(pagy.records.first.id).must_equal 21
          _(pagy.next).must_equal 3
          _(pagy.update).must_equal %w[key root page]
        end
      end

      describe 'column selection' do
        it 'adds required keyset columns to select' do
          set = model.order(:animal, :name, :id).select(:name)
          pagy = Pagy::Keyset::Keynav.new(set, limit: 10)
          pagy.records # Trigger query

          # Inspect internal set
          final_set = pagy.instance_variable_get(:@set)
          selected = model == Pet ? final_set.select_values.map(&:to_sym) : final_set.opts[:select]

          _(selected.sort).must_equal %i[animal id name]
        end
      end

      describe 'integrity (crawling)' do
        def slurp_by_page(page: nil, records: [], &block)
          result = yield(page)
          records << result[:records]
          result[:page] ? slurp_by_page(page: result[:page], records: records, &block) : records
        end

        let(:mixed_set) do
          if model == Pet
            model.order(animal: :asc, birthdate: :desc, id: :asc)
          else
            model.order(:animal, Sequel.desc(:birthdate), :id)
          end
        end

        [:id, %i[animal name id]].each do |order_args| # rubocop:disable Performance/CollectionLiteralInLoop
          it "crawls all records ordered by #{order_args}" do
            set = order_args == :id ? ordered_set : model.order(*order_args)

            cutoff_list = [nil]
            pages = slurp_by_page do |page|
              page ||= 1
              page_token = ['key', page, cutoff_list.size, cutoff_list[page - 1], cutoff_list[page]]

              pagy = Pagy::Keyset::Keynav.new(set, page: page_token, limit: 9)

              cutoff_list << pagy.instance_variable_get(:@page_cutoff)
              { records: pagy.records, page: pagy.next }
            end

            collection = set.to_a
            _(collection.size).must_equal 50
            _(pages.flatten).must_equal collection
          end
        end

        it "crawls mixed order set" do
          set = mixed_set
          cutoff_list = [nil]
          pages = slurp_by_page do |page|
            page ||= 1
            page_token = ['key', page, cutoff_list.size, cutoff_list[page - 1], cutoff_list[page]]
            pagy = Pagy::Keyset::Keynav.new(set, page: page_token, limit: 9)
            cutoff_list << pagy.instance_variable_get(:@page_cutoff)
            { records: pagy.records, page: pagy.next }
          end

          collection = set.to_a
          _(collection.size).must_equal 50
          _(pages.flatten).must_equal collection
        end
      end
    end
  end
end
