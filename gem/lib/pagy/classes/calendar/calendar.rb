# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class Pagy
  # Calendar class
  class Calendar < Hash
    path = Pathname.new(__dir__)
    autoload :Unit,    path.join('unit')
    autoload :Day,     path.join('day')
    autoload :Week,    path.join('week')
    autoload :Month,   path.join('month')
    autoload :Quarter, path.join('quarter')
    autoload :Year,    path.join('year')

    # List of units in desc order of duration. It can be used for custom units.
    UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant

    class << self
      # :nocov:
      # Localize with rails-i18n in any env
      def localize_with_rails_i18n_gem(*locales)
        Unit.prepend(Module.new { def localize(...) = ::I18n.localize(...) })
        raise RailsI18nLoadError, "Pagy: The gem 'rails-i18n' must be installed if you don't use Rails" \
              unless (path = Gem.loaded_specs['rails-i18n']&.full_gem_path)

        path = Pathname.new(path)
        ::I18n.load_path += locales.map { |locale| path.join("rails/locale/#{locale}.yml") }
      end
      # :nocov:

      private

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
                            = create(unit, **conf[unit]).send(:page_at, time, **)
        conf[unit][:params] ||= {}
        conf[unit][:params].merge!(page_syms)
        create(unit, **conf[unit])
      end.send(:compose_page_url, 1, **)
    end

    private

    # Create the calendar
    def init(conf, period, params)
      @conf     = Marshal.load(Marshal.dump(conf))  # store a copy
      @units    = Calendar::UNITS & @conf.keys # get the units in time length desc order
      @period   = period
      @params   = params
      @page_sym = conf[:offset][:page_sym] || Pagy::DEFAULT[:page_sym]
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

        calendar[unit] = object = create(unit, **conf[unit])
      end
      [replace(calendar), object.from, object.to]
    end

    # Create a unit subclass instance by using the unit name (internal use)
    def create(unit, **)
      raise InternalError, "unit must be in #{UNITS.inspect}; got #{unit}" unless UNITS.include?(unit)

      name    = +unit.to_s
      name[0] = name[0].capitalize
      Pagy::Calendar.const_get(name).new(**, request: @conf[:request])
    end
  end
end
