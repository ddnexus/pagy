# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/keyset/adapters/active_record'

describe Pagy::Keyset::Adapters::ActiveRecord do
  # Host class to mix in the adapter
  let(:adapter_host) do
    Class.new do
      include Pagy::Keyset::Adapters::ActiveRecord

      attr_accessor :set, :keyset

      def initialize(set, keyset = { name: :asc })
        @set    = set
        @keyset = keyset
      end
    end
  end

  let(:scope) { Pet.all }
  let(:host)  { adapter_host.new(scope) }

  describe '#extract_keyset' do
    it 'extracts standard column ordering' do
      host.set = Pet.order(name: :asc, animal: :desc)
      keyset   = host.send(:extract_keyset)
      _(keyset).must_equal({ name: :asc, animal: :desc })
    end

    it 'extracts table-qualified column ordering' do
      host.set = Pet.order(Pet.arel_table[:name].asc)
      keyset   = host.send(:extract_keyset)
      _(keyset).must_equal({ name: :asc })
    end
  end

  describe '#keyset_attributes_from' do
    it 'extracts keyset attributes from a record' do
      pet = Pet.first
      host.keyset = { name: :asc, animal: :desc }

      attrs = host.send(:keyset_attributes_from, pet)
      _(attrs).must_equal({ 'name' => pet.name, 'animal' => pet.animal })
    end
  end

  describe '#quoted_identifiers' do
    it 'returns properly quoted identifiers' do
      host.keyset = { name: :asc, animal: :desc }
      quoted = host.send(:quoted_identifiers, 'pets')

      # SQLite usually uses double quotes
      _(quoted[:name]).must_match(/"pets"."name"/)
      _(quoted[:animal]).must_match(/"pets"."animal"/)
    end
  end

  describe '#typecast' do
    it 'typecasts string inputs to model types' do
      # Birthdate is a Date column, input is String
      input = { 'birthdate' => '2023-01-01', 'name' => 'Test' }
      host.keyset = { birthdate: :asc, name: :asc }

      casted = host.send(:typecast, input)
      # ActiveRecord should cast the string '2023-01-01' to a Date object
      _(casted[:birthdate]).must_be_kind_of Date
      _(casted[:birthdate]).must_equal Date.new(2023, 1, 1)
      _(casted[:name]).must_equal 'Test'
    end
  end

  describe '#ensure_select' do
    it 'does nothing if no select is applied' do
      original_sql = host.set.to_sql
      host.send(:ensure_select)
      _(host.set.to_sql).must_equal original_sql
    end

    it 'adds keyset columns if select is restricted' do
      host.keyset = { animal: :asc }
      host.set    = Pet.select(:name) # 'animal' is missing

      host.send(:ensure_select)

      # Verify 'animal' was added
      # select_values returns array of strings/symbols
      values = host.set.select_values.map(&:to_s)
      _(values).must_include 'animal'
    end
  end

  describe '#apply_where' do
    it 'applies the predicate to the query' do
      # (name = 'Luna')
      host.send(:apply_where, Pet.arel_table[:name].eq('Luna'), {})

      sql = host.set.to_sql
      _(sql).must_match(/WHERE "pets"."name" = 'Luna'/)
    end
  end
end
