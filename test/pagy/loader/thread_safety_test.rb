# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../files/models'
require_relative '../../mock_helpers/meilisearch'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

# Use calendar and a pagy-search for the great complexity of loading and thread safety risks
describe 'Autoload thread safety' do
  threads       = []
  shared_result = []
  times         = 100

  times.times do
    threads << Thread.new do
                 sleep(rand(500 / 1000))
                 Time.zone = "GMT"
                 Date.beginning_of_week = :sunday

                 period = [Time.zone.local(2022, 3, 1, 3), Time.zone.local(2023, 3, 10, 3)]
                 calendar, pagy_c, _records = MockApp::Calendar.new(params: { page: 1 })
                                                               .send(:pagy_calendar,
                                                                     Event.all,
                                                                     month: { period: period },
                                                                     pagy: {})

                 results = MockMeilisearch::Model.ms_search('a')
                 pagy_m  = MockApp.new.send(:pagy_meilisearch, results)

                 if calendar[:month].instance_of?(Pagy::Offset::Calendar::Month) &&
                    pagy_c.instance_of?(Pagy::Offset) &&
                    pagy_m.instance_of?(Pagy::Offset::Meilisearch)
                   shared_result << :success
                 end
               rescue Exception => e   # rubocop:disable Lint/ RescueException
                 shared_result << e.class
               end
  end
  threads.each(&:join)

  it "loads safely" do
    _(shared_result).must_equal Array.new(times, :success)
  end
  it "uses super" do
    _ { MockApp.new.pagy_unknown_method }.must_raise NoMethodError
  end
end
