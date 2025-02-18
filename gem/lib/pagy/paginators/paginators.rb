# frozen_string_literal: true

require_relative 'loader'

class Pagy
  # Relegate backend functions to get the value of options from params
  module Get
    module_function

    # Check the use of jsonapi and its consistency
    def jsonapi?(params, options)
      return false unless params[:page] && options[:jsonapi] # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    # Get the limit from the request
    def requested_limit(params, options)
      limit_sym = options[:limit_sym] || DEFAULT[:limit_sym]
      jsonapi?(params, options) ? params[:page][limit_sym] : params[limit_sym]
    end

    # Get the limit from request, options or DEFAULT
    def limit_from(params, options)
      return options[:limit] || DEFAULT[:limit] \
      unless options[:requestable_limit] && (limit = requested_limit(params, options))

      [limit.to_i, options[:requestable_limit]].min
    end

    # Get the page integer from the params
    def page_from(params, options, force_integer: true)
      page_sym = options[:page_sym] || DEFAULT[:page_sym]
      page     = jsonapi?(params, options) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end
  end

  # Module to include in the app controller
  module Paginators
    include Loader
  end
end
