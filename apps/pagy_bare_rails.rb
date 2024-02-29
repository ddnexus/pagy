# frozen_string_literal: true

# Basic Rails app to: (i) reproduce errors, (ii) experiment pagy.

## Setup
# 1. Install SqLite3 (an in-memory DB) e.g.
##   sudo apt install sqlite3
# 2. Optional: If using external services e.g. Meilisearch
##    docker pull getmeili/meilisearch:latest # Fetch latest Meilisearch image from Docker Hub
##    docker run -it --rm -p 7700:7700 getmeili/meilisearch:latest ./meilisearch -master-key=password
# 4. Run script in separate terminal window:
#     ruby pagy_bare_rails.rb

# NOTICE: if you get any installation error(s) with the following setup
# temporarily remove `pagy/Gemfile` and `pagy/Gemfile.lock` from the repository
# because they may interfere with the bundler/inline.

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  # Debuggers
  gem 'debug'
  # gem 'debase'
  # gem 'ruby-debug-ide'

  # gem 'pagy'            # <--install from rubygems
  gem 'pagy', path: '../' # <-- use the local repo

  # gem "rails", github: "rails/rails", branch: "main"
  gem 'rails', '~> 6.1'
  gem 'actionpack'
  gem 'railties'
  gem 'sqlite3'

  ## Optional: Meilisearch example
  # gem 'meilisearch-rails'
end

require 'debug'

## Pagy Set-up
# https://ddnexus.github.io/pagy/docs/extras
# https://ddnexus.github.io/pagy/docs/api/backend
require 'pagy/extras/meilisearch'
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

  ## Optional: Meilisearch example
  #  MeiliSearch::Rails.configuration = {
  #  meilisearch_host: 'http://localhost:7700',
  #  meilisearch_api_key: 'password' }
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.connection.create_table(:authors) do |t|
  t.text :name
end

ActiveRecord::Base.connection.create_table(:books) do |t|
  t.text :name
  t.references :author, foreign_key: true
end

ActiveRecord::Base.logger = Logger.new($stdout)

class Author < ActiveRecord::Base # :nodoc:
  has_many :books

  ## Optional: Meilisearch example
  # include MeiliSearch::Rails
  # extend Pagy::Meilisearch
  #
  # meilisearch do
  #  attribute :name
  # end
end # :nodoc:

class Book < ActiveRecord::Base # :nodoc:
  belongs_to :author

  ## Optional: Meilisearch example
  # include MeiliSearch::Rails
  # extend Pagy::Meilisearch
  # meilisearch do
  #  attribute :name
  # end
end # :nodoc:

1.upto(11) do |i|
  Author.create(name: i)
end

Author.all.each_with_index do |_author, _i|
  Book.create(:author, :name)
end

## Optional: Meilisearch example
# Book.reindex!

class TestController < ActionController::Base # :nodoc:
  include Rails.application.routes.url_helpers
  include Pagy::Backend

  def index
    meta, @books = pagy(Book.all, items: 10)

    ## Optional: Meilisearch example
    # books         = Book.includes(:author).pagy_search('*')
    # @pagy, @books = pagy_meilisearch(books, items: 10)
    # @books.each(&:author)

    render json: { data: @books, meta: pagy_metadata(meta) }
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
    assert_equal response.parsed_body, { 'data' => Book.first(10).as_json, 'meta' =>
                                         { 'first_url' => '/?page=1', 'last_url' => '/?page=1' } }
  end

  def test_my_pagy_problem_here
    assert false
  end

  private

  def app
    Rails.application
  end
end

## or use rack to test:
# class BugTest < Minitest::Test # :nodoc:
#   include Rack::Test::Methods
#
#   # def test_my_pagy_problem_again
#   #  get '/'
#   #  assert last_response.ok?
#   # end
#
#   private
#
#   def app
#     Rails.application
#   end
# end
