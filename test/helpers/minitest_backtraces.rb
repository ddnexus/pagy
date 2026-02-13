# frozen_string_literal: true

# /usr/local/lib/ruby/gems/3.4.0/gems/minitest-5.25.4/lib/minitest.rb
module Minitest
  class UnexpectedError
    module AvoidBacktraceMangling
      def message # :nodoc:
        bt = Minitest.filter_backtrace(backtrace)
                     .map { |p| p.sub(%r{^#{Dir.pwd}/}, '') }
                     .join("\n    ")
        "#{error.class}: #{error.message}\n    #{bt}"
      end
    end
    prepend AvoidBacktraceMangling
  end

  # /home/dd/.local/share/JetBrains/Toolbox/apps/rubymine/plugins/ruby/rb/testing/patch/testunit/minitest/rm_reporter_plugin.rb
  # class RubyMineReporter < Reporter
  #   module AvoidDoubleBacktrace
  #     def with_message_and_backtrace(result)
  #       exception = result.failure
  #       msg       = "#{exception.class.name}: #{exception.message}" if exception
  #       unless result.error? # Avoid double backtrace for errors (included in msg)
  #         backtrace = "    " + Minitest.filter_backtrace(exception.backtrace)
  #                                      .map { |p| p.sub(%r{^#{Dir.pwd}/}, '') }
  #                                      .join("\n    ")
  #       end
  #       yield(msg, backtrace)
  #     end
  #   end
  #   prepend AvoidDoubleBacktrace
  # end
end
