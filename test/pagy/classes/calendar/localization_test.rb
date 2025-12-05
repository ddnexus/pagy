# frozen_string_literal: true

require 'test_helper'
require 'mock_helpers/app'
require 'pagy/toolbox/helpers/support/a_lambda'

describe 'Calendar with I18n.localize' do
  before do
    # Save Global State (Time, Date, I18n)
    @original_time_zone = Time.zone
    @original_bow       = Date.beginning_of_week
    @original_locale    = I18n.locale
    @original_load_path = I18n.load_path.dup

    # Configure Environment for this test
    Time.zone = 'Etc/GMT+5'
    Date.beginning_of_week = :sunday

    # Load the Gem
    require 'rails-i18n'

    # Apply the Patch
    # WARNING: This prepends a module to Pagy::Calendar::Unit.
    # This cannot be undone in this process, but we clean up the I18n config below.
    Pagy::Calendar.localize_with_rails_i18n_gem(:de)
  end

  after do
    # Restore Global State
    Time.zone              = @original_time_zone
    Date.beginning_of_week = @original_bow
    I18n.locale            = @original_locale

    # Critical: Remove the German locales added by the patch
    # so other tests don't accidentally pick them up.
    I18n.load_path         = @original_load_path
    I18n.reload!
  end

  it 'works in :en and :de' do
    # Define start/end times
    t1 = Time.zone.local(2021, 10, 21, 13, 18, 23, 0)
    t2 = Time.zone.local(2023, 11, 13, 15, 43, 40, 0)

    pagy = Pagy::Calendar::Month.new(period: [t1, t2], page: 3, format: '%B, %A')

    # Default Locale (:en)
    _(pagy.send(:page_label, 3)).must_equal "December, Wednesday"
    _(pagy.send(:page_label, 3, locale: :de)).must_equal "Dezember, Mittwoch"

    # Formats
    _(pagy.send(:page_label, 3, format: '%b')).must_equal "Dec"
    _(pagy.send(:page_label, 3, format: '%b', locale: :de)).must_equal "Dez"
    _(pagy.send(:page_label, 5)).must_equal "February, Tuesday"
    _(pagy.send(:page_label, 5, locale: :de)).must_equal "Februar, Dienstag"

    # Switch Global Locale to :de
    I18n.locale = :de
    _(pagy.send(:page_label, 3)).must_equal "Dezember, Mittwoch"
    _(pagy.send(:page_label, 3, format: '%b')).must_equal "Dez"
    _(pagy.send(:page_label, 5)).must_equal "Februar, Dienstag"
    _(pagy.send(:page_label, 5, format: '%b')).must_equal "Feb"

    # (Teardown handles setting locale back to :en)
  end
  it 'defaults to strftime localization (covering the original method)' do
    # 1. Grab the ORIGINAL method definition directly from the class
    #    This ignores any modules prepended by other tests (like rails-i18n)
    original_localize = Pagy::Calendar::Unit.instance_method(:localize)

    # 2. Setup test data
    time   = Time.now
    format = '%Y-%m-%d'

    # 3. Create a bare instance to bind the method to
    #    (.allocate skips initialize, which is fine as 'localize' doesn't use instance vars)
    instance = Pagy::Calendar::Unit.allocate

    # 4. Bind and Call the original method manually
    result = original_localize.bind_call(instance, time, format: format)

    # 5. Verify it worked
    _(result).must_equal time.strftime(format)
  end
end
