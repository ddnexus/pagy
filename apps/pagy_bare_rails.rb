# frozen_string_literal: true

# Self-contained, bare rails app, usable to play with pagy
# and/or easily reproduce any pagy issue.

# Edit this file as you need

# USAGE:
#     ruby pagy_bare_rails.rb

# NOTICE: if you get any installation error(s) with the following setup
# temporarily remove `pagy/Gemfile` and `pagy/Gemfile.lock` from the repository
# because they may interfere with the bundler/inline.

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  # Debuggers
  # gem 'debug'

  # gem 'debase'
  # gem 'ruby-debug-ide'

  # gem 'pagy'            # <--install from rubygems
  gem 'pagy', path: '../' # <-- use the local repo

  # gem "rails", github: "rails/rails", branch: "main"
  gem 'rails', '~> 6.1'
  gem 'actionpack'
  gem 'railties'
end

# Set up debugging tools
# require "debug" ## etc

# pagy initializer - add your requirements here:
# https://ddnexus.github.io/pagy/extras
# https://ddnexus.github.io/pagy/api/backend

# Edit this section as you need
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
require 'pagy/extras/trim'

Pagy::DEFAULT[:trim_extra] = false
Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:metadata] = %i[first_url last_url]
Pagy::DEFAULT[:overflow] = :empty_page

# Rails set up:
require 'action_controller/railtie'
require 'active_record'

require 'minitest/autorun' # runs tests automatically

class TestApp < Rails::Application # :nodoc:
  config.root = __dir__
  config.hosts << 'www.example.com'
  config.hosts << 'example.org'
  config.session_store :cookie_store, key: 'cookie_store_key'
  secrets.secret_key_base = 'secret_key_base'

  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

  routes.draw do
    get '/' => 'test#index', as: 'test'
  end
end

class Record < ActiveRecord::Base; end # :nodoc:

class TestController < ActionController::Base # :nodoc:
  include Rails.application.routes.url_helpers

  include Pagy::Backend

  def index
    meta, _records = pagy(Record.none, items: 10)
    render json: { data: [], meta: pagy_metadata(meta) }
  end

  ## override pagy methods if you need to here:
  # def pagy_get_items(collection, pagy)
  #  collection.limit(1)
  # end
end

class TestControllerTest < ActionDispatch::IntegrationTest # :nodoc:
  # Request helpers: https://api.rubyonrails.org/v6.1.4/classes/ActionDispatch/Integration/RequestHelpers.html
  # Available assertions: https://guides.rubyonrails.org/testing.html#available-assertions
  # Rails assertions: https://guides.rubyonrails.org/testing.html#rails-specific-assertions

  test 'pagy json output - example' do
    get '/'
    assert_equal response.parsed_body, { 'data' => [], 'meta' => { 'first_url' => '/?page=1', 'last_url' => '/?page=1' } }
  end

  def test_my_pagy_problem_here
    assert false
  end

  private

  def app
    Rails.application
  end
end

# or use rack to test:
class BugTest < Minitest::Test # :nodoc:
  include Rack::Test::Methods

  def test_my_pagy_problem_again
    get '/'
    assert last_response.ok?
  end

  private

  def app
    Rails.application
  end
end
