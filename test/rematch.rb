# frozen_string_literal: true

require 'yaml/store'

# Super simple and effective snapshot-like testing
#
# Instead of copying and pasting large helper outputs or big ruby
# structures into the test files and updating them manually every time,
# this class uses a YAML::Store file per each test file
#
# The first time a new `must_rematch` is run (i.e. it is not yet in the store file)
# it records its returned value, so the next times the same test is run,
# it will rematch its fresh returned value against the stored value.
# Obviously, the test will fail if the values don't match.
#
# You can update the values (or purge the unused values) in a few ways:
#  * delete the specific store file that you want to update
#    (e.g. frontend_test.rb.yml) and rerun the test
#  * run the rematch_all task (which will regenerate all the store files)
#  * manually edit the store file (useful only to try to fail a test)

class Pagy
  class Rematch
    def initialize(path:, base:)
      @store = YAML::Store.new("#{path}.yml", true)
      @base  = base
      @count = 0
    end

    def rematch(value)
      key = "#{@base} #{@count += 1}"
      @store.transaction { |s| s.root?(key) ? s[key] : s[key] = value }
    end

    module Minitest
      def before_setup
        @rematch = Rematch.new(path: method(name).source_location.first, base: location)
        super
      end
      def assert_rematch(_expected, actual)
        assert_equal(@rematch.rematch(actual), actual)
      end
      infect_an_assertion :assert_rematch, :must_rematch if respond_to? :infect_an_assertion
    end
  end
end
