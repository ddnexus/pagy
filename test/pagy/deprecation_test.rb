# frozen_string_literal: true

require_relative '../test_helper'

describe 'pagy/deprecation' do

  describe 'Pagy.deprecated_var' do
    it 'deprecates arg and returns right value' do
      assert_output('', "[PAGY WARNING] deprecated use of `var` var will not be supported in 5.0! Use `new_var: \"new-value\"` instead.") do
        _(Pagy.deprecated_var(:var, 'deprecated-val', :new_var, 'new-value')).must_equal 'new-value'
      end
    end
  end

  describe 'Pagy.deprecated_arg' do
    it 'deprecates arg and returns right value' do
      assert_output('', "[PAGY WARNING] deprecated use of positional `arg` arg will not be supported in 5.0! Use only the keyword arg `new_key: \"new-value\"` instead.") do
        _(Pagy.deprecated_arg(:arg, 'deprecated-val', :new_key, 'new-value')).must_equal 'new-value'
      end
    end
  end

  describe 'Pagy.deprecated_order' do
    it 'deprecates arg order and returns them inverted' do
      assert_output('', "[PAGY WARNING] inverted use of pagy/page in pagy_url_for will not be supported in 5.0! Use pagy_url_for(pagy, page) instead.") do
        _(Pagy.deprecated_order('page', 'pagy')).must_equal %w[pagy page]
      end
    end
  end
end
