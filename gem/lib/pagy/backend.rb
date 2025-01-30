# frozen_string_literal: true

require_relative 'modules/url'
require_relative 'backend/loader'

class Pagy
  # Relegate backend functions
  module Back
    module_function

    # Check whether it uses jsonapi and the params are consistent
    def jsonapi?(params, opts)
      return false unless params[:page] && opts[:jsonapi] # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    # Get the limit from the request
    def requested_limit(params, opts)
      limit_sym = opts[:limit_sym] || DEFAULT[:limit_sym]
      jsonapi?(params, opts) ? params[:page][limit_sym] : params[limit_sym]
    end
  end

  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_*` methods in your controller.
  module Backend
    private

    include Url

    # Get the limit from request, opts or DEFAULT
    def pagy_get_limit(opts)
      return opts[:limit] || DEFAULT[:limit] unless opts[:requestable_limit] && (limit = Back.requested_limit(params, opts))

      [limit.to_i, opts[:requestable_limit]].min
    end

    # Get the page integer from the params
    def pagy_get_page(opts, force_integer: true)
      page_sym = opts[:page_sym] || DEFAULT[:page_sym]
      page     = Back.jsonapi?(params, opts) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end

    include Backend::Loader
  end
end
