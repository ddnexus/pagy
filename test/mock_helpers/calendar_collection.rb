# frozen_string_literal: true

require 'yaml'
require_relative 'collection'

class MockCalendarCollection < MockCollection

  START_DATE = Time.new(2021, 10, 21, 13, 18, 23).utc
  END_DATE   = Time.new(2023, 11, 13, 15, 43, 40).utc
  YAML_FILE  = 'test/files/calendar_collection.yml'
  COLLECTION = YAML.load_file YAML_FILE

  def initialize(arr=COLLECTION)
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
