# frozen_string_literal: true

require_relative '../test_helper'

describe 'pagy/deprecation' do

  describe 'Pagy.deprecated_var' do
    it 'deprecate arg and returns right value' do
      _ { _(Pagy.deprecated_var(:var, 'deprecated-val', :new_var, 'new-value')).must_equal 'new-value' }.must_output nil, \
          "[PAGY WARNING] deprecated use of `var` var will not be supported in 5.0! Use `new_var: \"new-value\"` instead."
    end
  end

  describe 'Pagy.deprecated_arg' do
    it 'deprecate arg and returns right value' do
      _ { _(Pagy.deprecated_arg(:arg, 'deprecated-val', :new_key, 'new-value')).must_equal 'new-value' }.must_output nil, \
          "[PAGY WARNING] deprecated use of positional `arg` arg will not be supported in 5.0! Use only the keyword arg `new_key: \"new-value\"` instead."
    end
  end

  describe 'Pagy.deprecated_order' do
    it 'deprecate arg order and returns them inverted' do
      _ { _(Pagy.deprecated_order('page', 'pagy')).must_equal %w[pagy page] }.must_output nil, \
          "[PAGY WARNING] inverted use of pagy/page in pagy_url_for will not be supported in 5.0! Use pagy_url_for(pagy, page) instead."
    end
  end
end
