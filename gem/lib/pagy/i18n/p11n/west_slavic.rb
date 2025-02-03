# frozen_string_literal: true

class Pagy
  module I18n
    module P11n
      module WestSlavic
        module_function

        def plural_for(n = 0)
          case n
          when 1       then :one
          when 2, 3, 4 then :few
          else              :other
          end
        end
      end
    end
  end
end
