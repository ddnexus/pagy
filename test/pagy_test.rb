# frozen_string_literal: true

require_relative 'test_helper'

describe Pagy do
  it 'has version' do
    _(Pagy::VERSION).wont_be_nil
  end

  it 'has root' do
    _(Pagy::ROOT).must_be_kind_of Pathname
  end

  it 'has default' do
    _(Pagy::DEFAULT).must_be_kind_of Hash
    _(Pagy::DEFAULT[:limit]).must_equal 20
    _(Pagy::DEFAULT[:limit_key]).must_equal 'limit'
    _(Pagy::DEFAULT[:page_key]).must_equal 'page'
  end

  it 'has options' do
    _(Pagy.options).must_be_kind_of Hash
  end

  it 'includes modules' do
    _(Pagy.included_modules).must_include Pagy::Linkable
    _(Pagy.included_modules).must_include Pagy::Loader
    _(Pagy.singleton_class.included_modules).must_include Pagy::Configurable
  end

  describe 'instance methods' do
    let(:pagy) { Pagy.allocate }

    it 'defines identity methods' do
      _(pagy.send(:offset?)).must_equal false
      _(pagy.send(:countless?)).must_equal false
      _(pagy.send(:calendar?)).must_equal false
      _(pagy.send(:search?)).must_equal false
      _(pagy.send(:keyset?)).must_equal false
      _(pagy.send(:keynav?)).must_equal false
    end
  end

  describe 'protected methods' do
    let(:mock_pagy_class) do
      Class.new(Pagy) do
        # Define DEFAULT on the anonymous class
        const_set(:DEFAULT, { val: 10 }.freeze)

        def initialize(opts = {})
          assign_options(**opts)
        end

        def check(name_min)
          assign_and_check(name_min)
        end
      end
    end

    it 'merges options with defaults' do
      # Merges Pagy::DEFAULT and anonymous class DEFAULT
      pagy = mock_pagy_class.new(page: 2)
      _(pagy.options[:limit]).must_equal 20    # Inherited from Pagy
      _(pagy.options[:val]).must_equal 10      # From anonymous class
      _(pagy.options[:page]).must_equal 2      # Override
    end

    it 'filters nil/empty options matching defaults' do
      # If an option is in DEFAULT and passed as nil/empty, it keeps the default
      pagy = mock_pagy_class.new(limit: nil, val: '')
      _(pagy.options[:limit]).must_equal 20
      _(pagy.options[:val]).must_equal 10
    end

    it 'assigns and checks values' do
      pagy = mock_pagy_class.new(limit: 10, page: '5')
      pagy.check(limit: 1, page: 1)

      _(pagy.limit).must_equal 10
      _(pagy.page).must_equal 5 # converted to int
    end

    it 'raises OptionError for missing keys or invalid values' do
      pagy = mock_pagy_class.new
      # Missing key in options
      err = _ { pagy.check(missing: 1) }.must_raise Pagy::OptionError
      _(err.message).must_match 'expected :missing >= 1; got nil'

      # Invalid value (less than min)
      pagy = mock_pagy_class.new(limit: 0)
      err = _ { pagy.check(limit: 1) }.must_raise Pagy::OptionError
      _(err.message).must_match 'expected :limit >= 1; got 0'

      # Invalid value (not a number)
      pagy = mock_pagy_class.new(limit: 'invalid')
      err = _ { pagy.check(limit: 1) }.must_raise Pagy::OptionError
      _(err.message).must_match 'expected :limit >= 1; got "invalid"'
    end
  end
end
