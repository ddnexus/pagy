# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'groupdate'
require 'rack'

# Backend and Frontend poor man mock app
class MockApp
  attr_reader :params, :request, :response

  include Pagy::Backend
  include Pagy::Frontend

  # App params are merged into the @request.params (and are all strings)
  # @params are taken from @request.params and merged with app params (which fixes symbols and strings in params)
  def initialize(url: 'http://example.com:3000/foo', params: { page: 3 })
    @request  = Rack::Request.new(Rack::MockRequest.env_for(url, params: params))
    @params   = ActiveSupport::HashWithIndifferentAccess.new(@request.params).merge(params)
    @response = Rack::Response.new
  end

  def test_i18n_call
    I18n.t('test')
  end

  def set_pagy_locale(locale) # rubocop:disable Naming/AccessorMethodName
    @pagy_locale = locale
  end

  class Calendar < MockApp
    def pagy_calendar_period(collection)
      starting = collection.minimum(:time)
      ending   = collection.maximum(:time)
      [starting.in_time_zone, ending.in_time_zone]
    end

    def pagy_calendar_filter(collection, from, to)
      collection.where(time: from...to)
    end
  end

  class CalendarCounts < Calendar
    def pagy_calendar_counts(collection, unit, from, to)
      # group_by_period is provided by the groupdate gem
      collection.group_by_period(unit, :time, range: from...to).count.values
    end
  end
end
