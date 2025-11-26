# frozen_string_literal: true

require 'simplecov'
require_relative '../gem/lib/pagy'

require 'minitest/autorun'
unless ENV['RM_INFO'] # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end
require_relative 'helpers/warning_filters'

require 'sqlite3'

Minitest.after_run do
  db_path = Pagy::ROOT.join('../test/files/db/test.sqlite3')
  if File.exist?(db_path)
    begin
      db = SQLite3::Database.new(db_path)
      db.execute('PRAGMA wal_checkpoint(TRUNCATE);')
      db.close
    rescue SQLite3::Exception => e
      puts "Error during WAL checkpoint: #{e.message}"
    end
  else
    puts "#{db_path} does not exist"
  end
end

# /usr/local/lib/ruby/gems/3.4.0/gems/minitest-5.25.4/lib/minitest.rb
module Minitest
  class UnexpectedError
    module AvoidBacktraceMangling
      def message # :nodoc:
        bt = Minitest.filter_backtrace(backtrace)
                     .map { |p| p.sub(%r{^#{Dir.pwd}/}, '') } # <-- ^ sub inside map and not gsub on string
                     .join("\n    ")
        "#{error.class}: #{error.message}\n    #{bt}"
      end
    end
    prepend AvoidBacktraceMangling
  end

  # /home/dd/.local/share/JetBrains/Toolbox/apps/rubymine/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb
  class RubyMineReporter < Reporter
    module AvoidDoubleBacktrace
      def with_message_and_backtrace(result)
        exception = result.failure
        msg       = "#{exception.class.name}: #{exception.message}" if exception
        unless result.error? # Avoid double backtrace for errors (included in msg)
          backtrace = "    " + Minitest.filter_backtrace(exception.backtrace)
                                       .map { |p| p.sub(%r{^#{Dir.pwd}/}, '') } # Relative paths as minitest does
                                       .join("\n    ")
        end
        yield(msg, backtrace)
      end
    end
    prepend AvoidDoubleBacktrace
  end
end

require 'uri'
module Minitest
  module Assertions
    def assert_url_equal(expected, actual, msg = nil)
      normalize = lambda do |url_str|
        u = URI(url_str) # handles both 'http://example.com/foo' and '/foo' automatically
        if u.query
          sorted  = URI.decode_www_form(u.query).sort
          u.query = URI.encode_www_form(sorted)
        end
        u.to_s
      end

      assert_equal normalize[expected], normalize[actual], msg
    end
  end

  module Expectations
    def must_equal_url(expected, msg = nil)
      # Minitest 6 compatible: use 'ctx' for assertion, 'target' for value
      ctx.assert_url_equal(expected, target, msg)
    end
  end
end
