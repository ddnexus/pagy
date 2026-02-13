# frozen_string_literal: true

require_relative '../test_helper'

require 'ferrum'
require 'socket'
require 'minitest/hooks/default'

require_relative 'helpers/pagy_app'
require_relative 'helpers/functions'

class E2eTest < Minitest::Spec
  include E2eFunctions

  before(:all) do
    app = E2eApp.new(app_id)
    self.class.instance_variable_set(:@app, app)
    app.start
  end

  def app = self.class.instance_variable_get(:@app)

  def app_id = @app_id ||= self.class.to_s.split.first.downcase.to_sym

  def browser
    @browser ||= Ferrum::Browser.new(url: "http://#{E2eApp::IP}:9222",
                                     base_url: app.base_url,
                                     timeout: 60)
  end

  after(:all) { app.stop }
end

Minitest::Spec.register_spec_type(E2eTest) do |_desc, *_args|
  caller.any? { _1.include?('/e2e/') } # Check for the /e2e/ directory
end

# Final safety net to stop any lingering servers after the entire test suite runs
Minitest.after_run { E2eApp.stop_all }
