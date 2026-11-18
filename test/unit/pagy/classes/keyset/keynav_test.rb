# frozen_string_literal: true

require 'unit/test_helper'
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

        let(:malformed_pages) do
          { 'storage key not a string' => [1, 2, 3, [10], [20]],
            'page not an integer'      => ['key', '2', 3, [10], [20]],
            'page not positive'        => ['key', 0, 3, nil, [10]],
            'page beyond last'         => ['key', 4, 3, [30], nil],
            'last not an integer'      => ['key', 2, '<b>', [10], [20]],
            'float last'               => ['key', 2, 3.5, [10], [20]],
            'prior cutoff not array'   => ['key', 2, 3, 10, [20]],
            'page cutoff not array'    => ['key', 2, 3, [10], 20],
            'cutoff of the wrong size' => ['key', 2, 3, [10], [20, 21]],
            'last page with a cutoff'  => ['key', 2, 2, [10], [20]],
            'page without its cutoff'  => ['key', 2, 3, [10], nil],
            'prior cutoff on page 1'   => ['key', 1, 3, [10], [20], [30]],
            'missing prior cutoff'     => ['key', 3, 5, nil, [30], [40]],
            'next cutoff beyond last'  => ['key', 2, 3, [10], [20], [30]],
            'missing next cutoff'      => ['key', 2, 5, [10], [20], nil],
            'not a page array'         => { 'key' => 2 } }
        end

        it 'restarts from page 1 with a malformed page' do
          malformed_pages.each do |reason, page|
            pagy = Pagy::Keyset::Keynav.new(ordered_set, page:, limit: 10, root_key: 'root')

            _(pagy.page).must_equal 1, reason
            _(pagy.last).must_equal 2, reason # the cutoff of the restarted page 1 has been added
            _(pagy.previous).must_be_nil reason
            _(pagy.records.first.id).must_equal 1, reason
            _(pagy.records.size).must_equal 10, reason
            _(pagy.update).must_equal [nil, 'root', 'page', 2, [1, 1, [10]], [nil, nil, nil]], reason
          end
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

          # Check update structure: [storage_key, root, page_key, next_page, [curr_page, 1, cutoff], seen_cutoffs]
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
          _(pagy.update[4].last).must_equal ["20"]
        end
      end

      describe 'page navigation' do
        it 'handles first page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set, limit: 10)

          _(pagy.next).must_equal 2
          # Update for page 1->2
          _(pagy.update).must_equal [nil, nil, 'page', 2, [1, 1, [10]], [nil, nil, nil]]
        end

        it 'handles middle page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 2, [10]],
                                          limit: 10)

          _(pagy.records.first.id).must_equal 11
          _(pagy.next).must_equal 3
          # Update for page 2->3
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, [20]], [[10], nil, nil]]
        end

        it 'returns the cutoffs sent by the client with the update' do
          # page format: [storage_key, page, last, prior_cutoff, page_cutoff, next_cutoff]
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 4, [10], [25], [30]], # page 2 holds 15 records
                                          limit: 10)

          _(pagy.update).must_equal ['key', nil, 'page', 5, [2, 0, [20]], [[10], [25], [30]]]
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

      describe 'grown page' do
        it 'splits the page for a client that guards the updates' do
          # 15 records between the cutoffs of page 2; the 6 items page array is sent by a guarding client
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 3, [10], [25], nil],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..20).to_a
          _(pagy.last).must_equal 4
          _(pagy.next).must_equal 3
          # The new cutoff is inserted before the old one
          _(pagy.update).must_equal ['key', nil, 'page', 4, [2, 0, [20]], [[10], [25], nil]]
        end

        it 'moves the cutoff for a client that does not guard the updates' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 3, [10], [25]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..20).to_a
          _(pagy.last).must_equal 3
          _(pagy.next).must_equal 3
          # The new cutoff replaces the old one
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, [20]], [[10], [25], nil]]
        end

        it 'limits the records of a forged cutoff' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 1, 2, nil, [1_000_000], nil],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (1..10).to_a
          _(pagy.update).must_equal ['key', nil, 'page', 3, [1, 0, [10]], [nil, [1_000_000], nil]]
        end
      end

      describe 'short page' do
        # The set without the records of page 2
        let(:holed_set) { model == Pet ? ordered_set.where.not(id: 11..20) : ordered_set.exclude(id: 11..20) }

        it 'merges the page with the next page that fits' do
          # 4 records in page 2 and 4 records in page 3
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 4, [10], [14], [18]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..18).to_a
          _(pagy.last).must_equal 3
          _(pagy.next).must_equal 3
          # The cutoff of the page is deleted
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1], [[10], [14], [18]]]
        end

        it 'keeps the page when the next page does not fit' do
          # 4 records in page 2 and 10 records in page 3
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 4, [10], [14], [24]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..14).to_a
          _(pagy.last).must_equal 4
          _(pagy.next).must_equal 3
          _(pagy.update).must_equal ['key', nil, 'page']
        end

        it 'keeps the page for a client that does not guard the updates' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 4, [10], [14]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..14).to_a
          _(pagy.update).must_equal ['key', nil, 'page']
        end

        it 'merges an empty page with the next page' do
          pagy = Pagy::Keyset::Keynav.new(holed_set,
                                          page:  ['key', 2, 4, [10], [20], [30]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (21..30).to_a
          _(pagy.last).must_equal 3
          _(pagy.next).must_equal 3
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1], [[10], [20], [30]]]
        end

        it 'skips an empty page when the next page has grown' do
          # 15 records in page 3
          pagy = Pagy::Keyset::Keynav.new(holed_set,
                                          page:  ['key', 2, 4, [10], [20], [35]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (21..30).to_a
          _(pagy.last).must_equal 4
          _(pagy.next).must_equal 3
          # The cutoff of the empty page is replaced by the cutoff of the limited next page
          _(pagy.update).must_equal ['key', nil, 'page', 4, [2, 1, [30]], [[10], [20], [35]]]
        end

        it 'fills the page from the last page' do
          # 4 records in page 2, followed by the last page
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 3, [10], [14], nil],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..20).to_a
          _(pagy.last).must_equal 3
          _(pagy.next).must_equal 3
          # The cutoff of the page is replaced
          _(pagy.update).must_equal ['key', nil, 'page', 3, [2, 1, [20]], [[10], [14], nil]]
        end

        it 'merges the page with the last page that fits' do
          # 4 records in page 5, and 6 records in the last page
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 5, 6, [40], [44], nil],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (41..50).to_a
          _(pagy.last).must_equal 5
          _(pagy.next).must_be_nil
          _(pagy.update).must_equal ['key', nil, 'page', 5, [5, 1], [[40], [44], nil]]
        end

        it 'keeps the full page' do
          pagy = Pagy::Keyset::Keynav.new(ordered_set,
                                          page:  ['key', 2, 4, [10], [20], [30]],
                                          limit: 10)

          _(pagy.records.map(&:id)).must_equal (11..20).to_a
          _(pagy.update).must_equal ['key', nil, 'page']
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
