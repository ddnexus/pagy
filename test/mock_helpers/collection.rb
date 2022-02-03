# frozen_string_literal: true

require 'yaml'

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
    START_DATE = Time.new(2021, 10, 21, 13, 18, 23).utc
    END_DATE   = Time.new(2023, 11, 13, 15, 43, 40).utc
    YAML_FILE  = File.expand_path('../files/calendar_collection.yml', __dir__)
    # :nocov:
    COLLECTION = if Psych::VERSION > '3.3.0'
                   YAML.safe_load(File.read(YAML_FILE), permitted_classes: [Time])
                 else
                   YAML.safe_load(File.read(YAML_FILE), [Time], [])
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

    # Commented out to avoid coverage miss
    # def self.generate_yml
    #   start_sec  = START_DATE.to_i
    #   end_sec    = END_DATE.to_i
    #   collection = []
    #   cur_sec    = start_sec
    #   while cur_sec < end_sec
    #     collection << Time.at(cur_sec).utc
    #     cur_sec += rand(60*60*24*3) # random  max 3 days
    #   end
    #   collection << Time.at(end_sec).utc
    #   File.open(YAML_FILE, 'w'){ |f| f.write collection.to_yaml }
    # end
  end
end
