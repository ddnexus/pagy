# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Initializes the calendar objects, reducing complexity in the extra
    # The returned calendar is a simple hash of units/objects with an added helper
    # returning the last_object_at(time) used in the extra
    class Helper < Hash
      class << self
        private

        def init(conf, period, params)
          new.send(:init, conf, period, params)
        end
      end

      private

      def init(conf, period, params)
        @units = Calendar::UNITS & conf.keys # get the units in time length desc order
        raise ArgumentError, 'no calendar unit found in pagy_calendar @configuration' if @units.empty?

        @period     = period
        @params     = params
        @page_param = conf[:pagy][:page_param] || DEFAULT[:page_param]
        @conf       = Marshal.load(Marshal.dump(conf))  # store a copy
        @units.each do |unit|  # set all the :page_param vars for later deletion
          unit_page_param         = :"#{unit}_#{@page_param}"
          conf[unit][:page_param] = unit_page_param
          conf[unit][:page]       = @params[unit_page_param]
        end
        calendar = {}
        object   = nil
        @units.each_with_index do |unit, index|
          params_to_delete    = @units[(index + 1), @units.size].map { |sub| conf[sub][:page_param] } + [@page_param]
          conf[unit][:params] = lambda do |unit_params|  # delete page_param from the sub-units
                                  # Hash#except missing from ruby 2.5 baseline
                                  params_to_delete.each { |p| unit_params.delete(p.to_s) }
                                  unit_params
                                end
          conf[unit][:period] = object&.send(:active_period) || @period
          calendar[unit]      = object = Calendar.send(:create, unit, conf[unit])
        end
        [replace(calendar), object.from, object.to]
      end

      def last_object_at(time)
        conf        = Marshal.load(Marshal.dump(@conf))
        page_params = {}
        @units.inject(nil) do |object, unit|
          conf[unit][:period] = object&.send(:active_period) || @period
          conf[unit][:page]   = page_params[:"#{unit}_#{@page_param}"] \
                              = Calendar.send(:create, unit, conf[unit]).send(:page_at, time)
          conf[unit][:params] ||= {}
          conf[unit][:params].merge!(page_params)
          Calendar.send(:create, unit, conf[unit])
        end
      end
    end
  end
end
