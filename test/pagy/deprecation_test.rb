# frozen_string_literal: true

require_relative '../test_helper'

describe 'pagy/deprecation' do

  STYLES=%w[bootstrap bulma foundation materialize navs semantic uikit].freeze # rubocop:disable Lint/ConstantDefinitionInBlock # we are actually in a test class
  STYLES.each { |name| require "pagy/extras/#{name}" }
  require 'pagy/extras/items'
  require 'pagy/extras/support'

  require_relative '../mock_helpers/view'
  let(:view) { MockView.new }
  let(:pagy) { Pagy.new(count: 100)}

  describe 'Pagy.deprecated_arg' do
    it 'deprecates arg and returns right value' do
      assert_output('', "[PAGY WARNING] deprecated use of positional 'arg' arg will not be supported in 5.0! Use only the keyword arg 'new_key: \"deprecated-val\"' instead.") do
        _(Pagy.deprecated_arg(:arg, 'deprecated-val', :new_key, 'new-value')).must_equal 'deprecated-val'
      end
    end
    it 'works with id/pagy_id arguments' do
      STYLES.each do |name|
        name_fragment = name == 'navs' ? '' : "#{name}_"
        assert_output('', "[PAGY WARNING] deprecated use of positional 'id' arg will not be supported in 5.0! Use only the keyword arg 'pagy_id: \"pagy-id\"' instead.") do
          view.send(:"pagy_#{name_fragment}nav_js", pagy, 'pagy-id')
        end
        assert_output('', "[PAGY WARNING] deprecated use of positional 'id' arg will not be supported in 5.0! Use only the keyword arg 'pagy_id: \"pagy-id\"' instead.") do
          view.send(:"pagy_#{name_fragment}combo_nav_js", pagy, 'pagy-id' )
        end
      end
      assert_output('', "[PAGY WARNING] deprecated use of positional 'id' arg will not be supported in 5.0! Use only the keyword arg 'pagy_id: \"pagy-id\"' instead.") do
        view.pagy_items_selector_js(pagy, 'pagy-id')
      end
    end
    it 'works with text and extra_link arguments' do
      %i[pagy_prev_link pagy_next_link].each do |meth|
        assert_output('', "[PAGY WARNING] deprecated use of positional 'text' arg will not be supported in 5.0! Use only the keyword arg 'text: \"my-text\"' instead.") do
          view.send(meth, pagy, 'my-text')
        end
        assert_output('', "[PAGY WARNING] deprecated use of positional 'link_extra' arg will not be supported in 5.0! Use only the keyword arg 'link_extra: \"link-extra\"' instead.") do
          view.send(meth, pagy, nil, 'link-extra')
        end
      end
    end
  end

  describe 'Pagy.deprecated_order' do
    it 'deprecates arg order and returns them inverted' do
      assert_output('', "[PAGY WARNING] inverted use of pagy/page in pagy_url_for will not be supported in 5.0! Use pagy_url_for(pagy, page) instead.") do
        _(Pagy.deprecated_order('page', 'pagy')).must_equal %w[pagy page]
      end
    end
    it 'works with pagy_url_for' do
      assert_output('', "[PAGY WARNING] inverted use of pagy/page in pagy_url_for will not be supported in 5.0! Use pagy_url_for(pagy, page) instead.") do
        view.pagy_url_for(2, pagy)
      end
    end
  end
end
