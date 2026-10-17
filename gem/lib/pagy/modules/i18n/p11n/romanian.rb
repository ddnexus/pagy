# frozen_string_literal: true

class Pagy
  module I18n
    module P11n
      module Romanian
        module_function

        def plural_for(n = 0)
          case
          when n == 1
            :one
          when n.zero? || (1..19).cover?(n % 100)
            :few
          else
            :other
          end
        end
      end
    end
  end
end
