# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class Pagy
  # Calendar class
  class Calendar < Hash
    autoload :Unit,    PAGY_PATH.join('calendar/unit')
    autoload :Day,     PAGY_PATH.join('calendar/day')
    autoload :Week,    PAGY_PATH.join('calendar/week')
    autoload :Month,   PAGY_PATH.join('calendar/month')
    autoload :Quarter, PAGY_PATH.join('calendar/quarter')
    autoload :Year,    PAGY_PATH.join('calendar/year')

    # List of units in desc order of duration. It can be used for custom units.
    UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant

    class << self
      # :nocov:
      # Localize with rails-i18n in any env
      def localize_with_rails_i18n_gem(*locales)
        Unit.prepend(Module.new { def localize(...) = ::I18n.l(...) })
        raise RailsI18nLoadError, "Pagy: The gem 'rails-i18n' must be installed if you don't use Rails" \
              unless (path = Gem.loaded_specs['rails-i18n']&.full_gem_path)

        path = Pathname.new(path)
        ::I18n.load_path += locales.map { |locale| path.join("rails/locale/#{locale}.yml") }
      end
      # :nocov:

      private

      # Create a unit subclass instance by using the unit name (internal use)
      def create(unit, **)
        raise InternalError, "unit must be in #{UNITS.inspect}; got #{unit}" unless UNITS.include?(unit)

        name    = +unit.to_s
        name[0] = name[0].capitalize
        Object.const_get("Pagy::Calendar::#{name}").new(**)
      end

      # Return calendar, from, to
      def init(...)
        new.send(:init, ...)
      end
    end

    # Return the current time of the smallest time unit shown
    def showtime
      self[@units.last].from
    end

    # Return the url for the calendar (shortest unit) page at time
    def url_at(time, **)
      conf      = Marshal.load(Marshal.dump(@conf))
      page_syms = {}
      @units.inject(nil) do |object, unit|
        conf[unit][:period] = object&.send(:active_period) || @period
        conf[unit][:page]   = page_syms[:"#{unit}_#{@page_sym}"] \
                            = Calendar.send(:create, unit, **conf[unit]).send(:page_at, time, **)
        conf[unit][:params] ||= {}
        conf[unit][:params].merge!(page_syms)
        Calendar.send(:create, unit, request: @request, **conf[unit])
      end.send(:page_url, 1, **)
    end

    private

    # Create the calendar
    def init(conf, period, params)
      @request = conf.delete(:request)
      @conf    = Marshal.load(Marshal.dump(conf))  # store a copy
      @units   = Calendar::UNITS & @conf.keys # get the units in time length desc order
      raise ArgumentError, 'no calendar unit found in pagy_calendar @configuration' if @units.empty?

      @period   = period
      @params   = params
      @page_sym = conf[:pagy][:page_sym] || Pagy::DEFAULT[:page_sym]
      # set all the :page_sym options for later deletion
      @units.each { |unit| conf[unit][:page_sym] = :"#{unit}_#{@page_sym}" }
      calendar = {}
      object   = nil
      @units.each_with_index do |unit, index|
        params_to_delete    = @units[(index + 1), @units.length].map { |sub| conf[sub][:page_sym] } + [@page_sym]
        conf[unit][:params] = ->(up) { up.except!(*params_to_delete.map(&:to_s)) }
        conf[unit][:period] = object&.send(:active_period) || @period
        conf[unit][:page]   = @params[:"#{unit}_#{@page_sym}"] # requested page
        # :nocov:
        # simplecov doesn't need to fail block_given?
        conf[unit][:counts] = yield(unit, conf[unit][:period]) if block_given?
        # :nocov:

        calendar[unit] = object = Calendar.send(:create, unit, request: @request, **conf[unit])
      end
      [replace(calendar), object.from, object.to]
    end
  end
end
