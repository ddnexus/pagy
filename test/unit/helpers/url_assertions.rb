# frozen_string_literal: true

require 'uri'

module Minitest
  module Assertions
    def assert_url_equal(expected, actual, msg = nil)
      normalize = lambda do |url_str|
        u = URI(url_str)
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
