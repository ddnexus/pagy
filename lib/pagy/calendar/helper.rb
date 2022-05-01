# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    class Helper < Hash # :nodoc:
      class << self
        private

        def create(conf, period, params)
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
        last_obj = nil
        @units.each_with_index do |unit, index|
          params_to_delete    = @units[(index + 1), @units.size].map { |sub| conf[sub][:page_param] } + [@page_param]
          conf[unit][:params] = lambda do |unit_params|  # delete page_param from the sub-units
                                  # Hash#except missing from ruby 2.5 baseline
                                  params_to_delete.each { |p| unit_params.delete(p.to_s) }
                                  unit_params
                                end
          conf[unit][:period] = last_obj&.send(:active_period) || @period
          calendar[unit]      = last_obj = Calendar.send(:create, unit, conf[unit])
        end
        [replace(calendar), last_obj.from, last_obj.to]
      end

      def last_object_at(date)
        conf = Marshal.load(Marshal.dump(@conf))
        units_params = {}
        last_obj     = nil
        @units.each do |unit|
          conf[unit][:period] = last_obj&.send(:active_period) || @period
          conf[unit][:page]   = current_page = Calendar.send(:create, unit, conf[unit]).send(:page_at, date)
          units_params[:"#{unit}_#{@page_param}"] = current_page
          conf[unit][:params] ||= {}
          conf[unit][:params].merge!(units_params)
          last_obj = Calendar.send(:create, unit, conf[unit])
        end
        last_obj
      end
    end
  end
end
