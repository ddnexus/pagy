# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/calendar/calendar'
require 'mocks/app'

describe Pagy::Calendar do
  let(:period) { [Time.zone.local(2021, 10, 21), Time.zone.local(2023, 11, 13)] }
  # Configuration mimicking what CalendarPaginator passes
  let(:conf) do
    # Ensure marshalable request
    mock_app_req = MockApp.new.request
    request_hash = { base_url: mock_app_req.base_url,
                     path:     mock_app_req.path,
                     params:   mock_app_req.params }
    { year:    { page_key: 'page' },
      month:   {},
      offset:  {},
      request: Pagy::Request.new(request: request_hash) }
  end
  let(:params) { { 'year_page' => '2', 'month_page' => '3' } }

  before { Time.zone = 'Etc/GMT+5' }
  after { Time.zone = 'Etc/UTC' }

  describe 'class methods' do
    it 'raises error if rails-i18n not found' do
      Gem.stub :loaded_specs, {} do
        _ { Pagy::Calendar.localize_with_rails_i18n_gem }.must_raise Pagy::RailsI18nLoadError
      end
    end

    describe 'with rails-i18n' do
      before do
        unless defined?(I18n)
          Object.const_set(:I18n, Module.new)
          I18n.define_singleton_method(:load_path) { @load_path ||= [] }
        end
        @original_load_path = I18n.load_path.dup
      end

      after do
        I18n.load_path.replace(@original_load_path) if @original_load_path
      end

      it 'loads locales and prepends module' do
        mock_spec = Minitest::Mock.new
        mock_spec.expect :full_gem_path, '/mock/gem/path'
        specs = { 'rails-i18n' => mock_spec }

        Gem.stub :loaded_specs, specs do
          Pagy::Calendar.localize_with_rails_i18n_gem(:en, :es)

          _(I18n.load_path).must_include Pathname.new('/mock/gem/path/rails/locale/en.yml')
          _(I18n.load_path).must_include Pathname.new('/mock/gem/path/rails/locale/es.yml')

          # Verify the class was modified (a new module is in the ancestry)
          _(Pagy::Calendar::Unit.ancestors.first).must_be_kind_of Module
          _(Pagy::Calendar::Unit.ancestors.first).wont_equal Pagy::Calendar::Unit
        end

        mock_spec.verify
      end
    end
  end

  describe '#init (via class proxy)' do
    it 'initializes nested units correctly' do
      calendar, from, to = Pagy::Calendar.send(:init, conf, period, params)

      _(calendar).must_be_kind_of Pagy::Calendar
      _(calendar.keys).must_include :year
      _(calendar.keys).must_include :month

      year = calendar[:year]
      _(year).must_be_kind_of Pagy::Calendar::Year
      _(year.page).must_equal 2
      _(year.from.year).must_equal 2022

      month = calendar[:month]
      _(month).must_be_kind_of Pagy::Calendar::Month
      _(month.page).must_equal 3
      _(month.from.year).must_equal 2022
      _(month.from.month).must_equal 3
      _(from).must_equal month.from
      _(to).must_equal month.to
    end
  end

  describe '#create (internal)' do
    it 'raises InternalError for invalid unit' do
      cal = Pagy::Calendar.new
      cal.instance_variable_set(:@conf, { request: nil })
      _ { cal.send(:create, :invalid_unit) }.must_raise Pagy::InternalError
    end
  end

  describe 'instance methods' do
    let(:calendar) { Pagy::Calendar.send(:init, conf, period, params)[0] }

    it 'returns showtime' do
      _(calendar.showtime).must_equal calendar[:month].from
    end

    it 'generates url_at specific time' do
      target = Time.zone.local(2022, 5, 15)
      url = calendar.url_at(target)

      _(url).must_include 'year_page=2'
      _(url).must_include 'month_page=5'
      _(url).must_include '/foo'
    end
  end
end
