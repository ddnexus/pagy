# frozen_string_literal: true

require 'yaml'

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class MockCollection < Array
  def initialize(arr = Array(1..1000))
    super
    @collection = clone
  end

  def offset(value)
    @collection = self[value..-1]
    self
  end

  def limit(value)
    if value == 1
      self # used in pluck
    else
      @collection[0, value]
    end
  end

  def count(*)
    size
  end

  def pluck(*)
    [size]
  end

  def group_values
    []
  end

  class Grouped < MockCollection
    def count(*)
      @collection.map { |value| [value, value + 1] }.to_h
    end

    def unscope(*)
      self
    end

    def group_values
      [:other_table_id]
    end
  end

  class Calendar < MockCollection
    YAML_FILE  = File.expand_path('../files/calendar_collection.yml', __dir__)
    # :nocov:
    COLLECTION = if Psych::VERSION > '3.3.0'
                   YAML.safe_load(File.read(YAML_FILE),
                                  permitted_classes: [ActiveSupport::TimeWithZone,
                                                      ActiveSupport::TimeZone,
                                                      Time],
                                  aliases: ["1"])
                 else
                   YAML.safe_load(File.read(YAML_FILE), [ActiveSupport::TimeWithZone,
                                                         ActiveSupport::TimeZone,
                                                         Time], [], true)
                 end
    # :nocov:

    def initialize(arr = COLLECTION)
      super
    end

    # Select days from the beginning of start_day to the end of end_day
    # Accepts strings or DateTime args
    def select_page_of_records(start_date, end_date)
      paged = select { |date| date >= start_date && date < end_date }
      # mock AR scope, returning the same type of object
      self.class.new(paged)
    end
  end
end
