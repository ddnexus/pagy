# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'groupdate'
require 'rack'
require 'uri'

class MockApp
  include Pagy::Method

  public :pagy # just for calling it without send

  attr_reader :request, :params

  # Initializer for a Rack::Request with defaults for test
  def initialize(url:     'http://example.com:3000/foo',
                 method:  :get,
                 params:  { page: 3 },
                 cookies: {},
                 headers: {},
                 indifferent_access: true)
    @indifferent_access     = indifferent_access
    env_opts                = { method: method.to_s.upcase, params: params }
    env_opts['HTTP_COOKIE'] = cookies.map { |k, v| "#{k}=#{v}" }.join('; ') unless cookies.empty?
    env_opts.merge!(headers)

    env         = Rack::MockRequest.env_for(url, env_opts)
    @request    = Rack::Request.new(env)
    rack_params = @request.params
    @params     = @indifferent_access ? ActiveSupport::HashWithIndifferentAccess.new(rack_params) : rack_params
  end

  def test_i18n_call
    I18n.t('test')
  end

  # -- Subclasses for specific Pagy calendar testing --

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
