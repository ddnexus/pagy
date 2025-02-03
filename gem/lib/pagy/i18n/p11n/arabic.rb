# frozen_string_literal: true

class Pagy
  module I18n
    module P11n
      module Arabic
        module_function

        def plural_for(n = 0)
          mod100 = n % 100
          case
          when n == 0                         then :zero # rubocop:disable Style/NumericPredicate
          when n == 1                         then :one
          when n == 2                         then :two
          when (3..10).to_a.include?(mod100)  then :few
          when (11..99).to_a.include?(mod100) then :many
          else                                     :other
          end
        end
      end
    end
  end
end
