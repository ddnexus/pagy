# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/keyset/adapters/sequel'
require 'files/models'

describe Pagy::Keyset::Adapters::Sequel do
  # Host class to mix in the adapter
  let(:adapter_host) do
    Class.new do
      include Pagy::Keyset::Adapters::Sequel

      attr_accessor :set, :keyset

      def initialize(set, keyset = { name: :asc })
        @set    = set
        @keyset = keyset
      end
    end
  end

  let(:dataset) { PetSequel.dataset }
  let(:host)    { adapter_host.new(dataset) }

  describe '#extract_keyset' do
    it 'extracts standard column ordering' do
      host.set = dataset.order(Sequel.asc(:name), Sequel.desc(:animal))
      keyset   = host.send(:extract_keyset)
      _(keyset).must_equal({ name: :asc, animal: :desc })
    end

    it 'extracts symbol ordering' do
      host.set = dataset.order(:name)
      keyset   = host.send(:extract_keyset)
      _(keyset).must_equal({ name: :asc })
    end

    it 'returns empty hash if no order' do
      host.set = dataset.unordered
      keyset   = host.send(:extract_keyset)
      _(keyset).must_equal({})
    end

    it 'raises TypeError for unsupported order types' do
      # Sequel.lit creates a Sequel::LiteralString, which is not supported
      host.set = dataset.order(Sequel.lit('name DESC'))
      _ { host.send(:extract_keyset) }.must_raise Pagy::Keyset::TypeError
    end
  end

  describe '#keyset_attributes_from' do
    it 'extracts keyset attributes from a record' do
      pet = PetSequel.first
      host.keyset = { name: :asc, animal: :desc }

      attrs = host.send(:keyset_attributes_from, pet)
      # Sequel model to_hash returns symbol keys usually
      _(attrs).must_equal({ name: pet.name, animal: pet.animal })
    end
  end

  describe '#quoted_identifiers' do
    it 'returns properly quoted identifiers' do
      host.keyset = { name: :asc, animal: :desc }
      quoted = host.send(:quoted_identifiers, 'pets_sequel')

      # Sequel quoting for sqlite uses backticks in this environment
      _(quoted[:name]).must_match(/`pets_sequel`\.`name`/)
      _(quoted[:animal]).must_match(/`pets_sequel`\.`animal`/)
    end
  end

  describe '#typecast' do
    it 'typecasts string inputs to model types' do
      input = { 'birthdate' => '2023-01-01', 'name' => 'Test' }
      host.keyset = { birthdate: :asc, name: :asc }

      casted = host.send(:typecast, input)
      _(casted[:birthdate]).must_be_kind_of Date
      _(casted[:birthdate]).must_equal Date.new(2023, 1, 1)
      _(casted[:name]).must_equal 'Test'
    end
  end

  describe '#ensure_select' do
    it 'does nothing if no select is applied' do
      original_sql = host.set.sql
      host.send(:ensure_select)
      _(host.set.sql).must_equal original_sql
    end

    it 'adds keyset columns if select is restricted' do
      host.keyset = { animal: :asc }
      host.set    = dataset.select(:name) # 'animal' is missing

      host.send(:ensure_select)

      # Verify 'animal' was appended. Sequel sql generation check.
      sql = host.set.sql
      _(sql).must_match(/`name`/)
      _(sql).must_match(/`animal`/)
    end
  end

  describe '#apply_where' do
    it 'applies the predicate to the query' do
      # Pagy::Keyset::Sequel#apply_where uses Sequel.lit(predicate, **arguments)
      # We must pass a Hash for the second argument.
      host.send(:apply_where, 'name = :n', { n: 'Luna' })

      sql = host.set.sql
      _(sql).must_match(/name = 'Luna'/)
    end
  end
end
