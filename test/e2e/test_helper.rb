# frozen_string_literal: true

ENV.delete('COVERAGE') # Allow to skip the coverage when used after its task

require_relative '../test_helper'

require 'ferrum'

require_relative 'helpers/e2e_app'
require_relative 'helpers/functions'

class E2eTest < Minitest::Spec
  include E2eFunctions

  def app = E2eApp.fetch(app_id)

  def app_id = @app_id ||= self.class.to_s.split.first.downcase.to_sym

  def browser
    @browser ||= Ferrum::Browser.new(base_url:        app.base_url,
                                     timeout:         30,
                                     process_timeout: 30, # many browsers may start at the same time
                                     window_size:     [1920, 1080],
                                     browser_options: { 'no-sandbox' => nil },
                                     extensions:      [{ source: E2eFunctions::PAGE_TRACKER }])
  end

  after { @browser&.quit }
end

Minitest::Spec.register_spec_type(E2eTest) do |_desc, *_args|
  caller.any? { _1.include?('/e2e/') } # Check for the /e2e/ directory
end

# Final safety net to stop any lingering servers after the entire test suite runs
Minitest.after_run { E2eApp.stop_all }
