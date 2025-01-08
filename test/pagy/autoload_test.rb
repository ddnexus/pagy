# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../files/models'
require_relative '../mock_helpers/app'

def app(**)
  MockApp::Calendar.new(**)
end

# Use calendar for the great complexity of autoloading, missing_method, Time.zone
describe 'Autoload thread safety' do
  threads       = []
  shared_result = []

  times = 1000

  times.times do
    threads << Thread.new do
                 sleep(rand(500 / 1000))
                 Time.zone = "GMT"
                 Date.beginning_of_week = :sunday

                 period = [Time.zone.local(2022, 3, 1, 3), Time.zone.local(2023, 3, 10, 3)]
                 calendar, pagy, _records = app(params: { page: 1 }).send(:pagy_calendar,
                                                                          Event.all,
                                                                          month: { period: period },
                                                                          pagy: {})
                 if calendar[:month].instance_of?(Pagy::Offset::Calendar::Month) && pagy.instance_of?(Pagy::Offset)
                   shared_result << :success
                 end
               rescue Exception => e   # rubocop:disable Lint/ RescueException
                 shared_result << e.class
               end
  end

  threads.each(&:join)

  it "autoload safely" do
    _(shared_result).must_equal Array.new(times, :success)
  end
end
