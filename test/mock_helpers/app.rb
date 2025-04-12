# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'groupdate'
require 'rack'

ActiveSupport.to_time_preserves_timezone = :zone  # Fix ActiveSupport deprecation

# Backend and Frontend poor man mock app
class MockApp
  attr_reader :request, :response

  def initialize(url: 'http://example.com:3000/foo', params: { page: 3 }, cookie: nil)
    env                = Rack::MockRequest.env_for(url, params: params)
    env["HTTP_COOKIE"] = cookie if cookie
    @request           = Rack::Request.new(env)
    @response          = Rack::Response.new
  end

  def params
    ActiveSupport::HashWithIndifferentAccess.new(@request.params)
  end

  def test_i18n_call
    I18n.t('test')
  end

  include Pagy::Method

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

  class CalendarCountsSkip < Calendar
    def pagy_calendar_counts(_collection, _unit, _from, _to)
      nil
    end
  end
end
