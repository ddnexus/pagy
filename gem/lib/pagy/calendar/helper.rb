# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Initializes the calendar objects, reducing complexity in the extra
    # The returned calendar is a simple hash of units/objects
    class Helper < Hash
      class << self
        private

        def init(conf, period, params)
          new.send(:init, conf, period, params)
        end
      end

      attr_reader :units

      private

      # Create the calendar
      def init(conf, period, params)
        @conf  = Marshal.load(Marshal.dump(conf))  # store a copy
        @units = Calendar::UNITS & @conf.keys # get the units in time length desc order
        raise ArgumentError, 'no calendar unit found in pagy_calendar @configuration' if @units.empty?

        @period     = period
        @params     = params
        @page_param = conf[:pagy][:page_param] || DEFAULT[:page_param]
        @units.each do |unit|  # set all the :page_param vars for later deletion
          unit_page_param         = :"#{unit}_#{@page_param}"
          conf[unit][:page_param] = unit_page_param
          conf[unit][:page]       = @params[unit_page_param]
        end
        calendar = {}
        object   = nil
        @units.each_with_index do |unit, index|
          params_to_delete    = @units[(index + 1), @units.size].map { |sub| conf[sub][:page_param] } + [@page_param]
          conf[unit][:params] = lambda { |up| up.except(*params_to_delete.map(&:to_s)) } # rubocop:disable Style/Lambda
          conf[unit][:period] = object&.send(:active_period) || @period
          calendar[unit]      = object = Calendar.send(:create, unit, conf[unit])
        end
        [replace(calendar), object.from, object.to]
      end

      # Return the calendar object at time
      def calendar_at(time, **opts)
        conf        = Marshal.load(Marshal.dump(@conf))
        page_params = {}
        @units.inject(nil) do |object, unit|
          conf[unit][:period] = object&.send(:active_period) || @period
          conf[unit][:page]   = page_params[:"#{unit}_#{@page_param}"] \
                              = Calendar.send(:create, unit, conf[unit]).send(:page_at, time, **opts)
          conf[unit][:params] ||= {}
          conf[unit][:params].merge!(page_params)
          Calendar.send(:create, unit, conf[unit])
        end
      end

      public

      # Return the current time of the smallest time unit shown
      def showtime
        self[@units.last].from
      end
    end
  end
end
