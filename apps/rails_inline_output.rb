# frozen_string_literal: true

# Self-contained, single action standalone Rails app usable as a support to reproduce pagy/rails issues.
# It is supposed to return an output that shows the problem.

require 'bundler/inline'

# Edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
# NOTICE: if you get any installation error with the following setup
# temporarily remove the Gemfile and Gemfile.lock from the repo (they may interfere with the bundler/inline)

gemfile(true) do
  source 'https://rubygems.org'

  gem 'rails', '~> 6.1.0'
  gem 'actionpack'
  gem 'railties'
  # gem 'pagy'            # <--install from rubygems
  gem 'pagy', path: '../' # <-- use the local repo
end

require 'rails'
require 'action_controller/railtie'
require 'active_record'

# pagy initializer
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:metadata] = %i[first_url last_url]
Pagy::DEFAULT[:overflow] = :empty_page

# Rails app
class TestApp < Rails::Application
  config.eager_load = 'development'
  config.consider_all_requests_local = true
  config.secret_key_base = 'anything'
  config.secret_token = 'anything'
  config.hosts = 'www.example.com'

  routes.append do
    get '/' => 'test#index', as: 'test'
  end
end

class Record < ActiveRecord::Base; end

# App controller
class TestController < ActionController::Base
  include Pagy::Backend

  def index
    meta, _records = pagy(Record.none, items: 10)
    render json: { data: [], meta: pagy_metadata(meta) }
  end
end

TestApp.initialize!

session = ActionDispatch::Integration::Session.new(Rails.application)

path = Rails.application.routes.url_helpers.test_path

session.get(path)

puts session.response.body
