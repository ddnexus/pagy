# frozen_string_literal: true

# :nocov:
module WarningFilters
  module Calendar
    def warn(message, category: nil, **kwargs)
      if message.match?('Calendar#page_at')
        # ignore
      else
        super
      end
    end
  end
end
Warning.extend WarningFilters::Calendar
# :nocov:
