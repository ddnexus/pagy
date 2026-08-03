# See https://ddnexus.github.io/pagy/guides/pagy-next/
# frozen_string_literal: true

ENV['PAGY_NEXT'] = 'true'
# simplecov:disable
require_relative '../pagy' unless defined?(Pagy)  # avoid circular require (also from pagy itself)
# simplecov:enable

class Pagy
  VERSION = "#{remove_const(:VERSION)}.next".freeze

  class NextError < ArgumentError; end

  module Discontinued
    # Ensure a discontinued option won't pass unnoticed shadowing a bug
    def assign_options(**options)
      discontinued = options.keys & %i[max_pages client_max_limit]
      return super if discontinued.empty?

      raise NextError, "discontinued #{discontinued.map(&:inspect).join(', ')}: " \
                       'check https://ddnexus.github.io/pagy/changelog/#deprecations for alternatives'
    end
  end
  prepend Discontinued
end
