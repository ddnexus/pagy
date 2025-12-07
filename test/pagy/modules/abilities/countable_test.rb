# frozen_string_literal: true

require 'test_helper'
require 'pagy/modules/abilities/countable'
require 'files/models'

describe Pagy::Countable do
  let(:countable) { Pagy::Countable }

  it 'counts arrays using size' do
    _(countable.get_count([1, 2, 3, 4], {})).must_equal 4
  end

  describe 'Sequel Dataset Logic' do
    # Use the existing PetSequel dataset from the test database
    let(:sequel_dataset) { PetSequel.dataset }

    it 'counts using simple count' do
      # Use the real count from the database
      expected_count = PetSequel.count
      _(countable.get_count(sequel_dataset, {})).must_equal expected_count
    end

    it 'handles grouped Sequel datasets' do
      # Create a grouped dataset by animal type
      grouped_dataset = PetSequel.dataset.group_and_count(:animal)

      # This should use the generic count method on the dataset
      result = countable.get_count(grouped_dataset, {})

      # Result should be the count of distinct animals
      _(result).must_equal PetSequel.select(:animal).distinct.count
    end
  end

  describe 'ActiveRecord Logic' do
    # Use the existing Pet relation from the test database
    let(:ar_collection) { Pet.all }

    it 'counts using count(:all) standard path' do
      # Use the real count from the database
      expected_count = Pet.count
      _(countable.get_count(ar_collection, {})).must_equal expected_count
    end

    it 'handles grouped Activerecord relation' do
      # Create a grouped relation by animal type
      grouped_relation = Pet.group(:animal)

      # This should use the generic count method on the dataset
      result = countable.get_count(grouped_relation, { count_over: true })

      # Result should be the count of distinct animals
      _(result).must_equal grouped_relation.count.size
    end

    it 'ignores count_over if no group values' do
      # Use an ungrouped relation with count_over option
      result = countable.get_count(ar_collection, { count_over: true })

      # Should use normal counting since there's no group
      _(result).must_equal Pet.count
    end
  end
end
