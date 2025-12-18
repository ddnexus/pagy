# frozen_string_literal: true

require 'active_record'
require 'sequel'

# Activerecord initializer
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Time.zone = 'Etc/UTC'

## Sequel initializer
Sequel.default_timezone = 'Etc/UTC'
DB = Sequel.connect(adapter: 'sqlite', database: ':memory:')

# Models for calendar tests
class Event < ActiveRecord::Base
end

class Event40 < ActiveRecord::Base
end

# Models for Keyset and generic DB collections tests
class Pet < ActiveRecord::Base
end

require_relative 'db_seed'

class PetSequel < Sequel::Model(:pets_sequel)
end
