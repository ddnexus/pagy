# frozen_string_literal: true

require 'active_record'
require 'sequel'

db_path = File.expand_path('db/test.sqlite3', __dir__)

# Activerecord initializer
# No logs in test
# ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_path)
Time.zone = 'Etc/UTC'

## Sequel initializer
Sequel.default_timezone = 'Etc/UTC'
DB = Sequel.connect(adapter: 'sqlite', user: 'root', password: 'password',
                    host: 'localhost', port: '3306', database: db_path)

# Models
class Event < ActiveRecord::Base
end

class Event40 < ActiveRecord::Base
end

class Pet < ActiveRecord::Base
end

require_relative 'db/seed' if ENV['REBUILD_TEST_DB']

class PetSequel < Sequel::Model(:pets_sequel)
end
