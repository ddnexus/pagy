# frozen_string_literal: true

require_relative 'modules/url'
require_relative 'backend/loader'

class Pagy
  # Relegate backend utilities methods that should not be used directly
  module Back
    module_function

    # Check whether it uses jsonapi and the params are consistent
    def jsonapi?(params, vars)
      return false unless params[:page] && vars[:jsonapi] # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    # Get the limit from the request
    def requested_limit(params, vars)
      limit_sym = vars[:limit_sym] || DEFAULT[:limit_sym]
      jsonapi?(params, vars) ? params[:page][limit_sym] : params[limit_sym]
    end
  end

  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_*` methods in your controller.
  module Backend
    private

    include Url

    # Get the limit from request, vars or DEFAULT
    def pagy_get_limit(vars)
      return vars[:limit] || DEFAULT[:limit] unless vars[:requestable_limit] && (limit = Back.requested_limit(params, vars))

      [limit.to_i, vars[:requestable_limit]].min
    end

    # Get the page integer from the params
    def pagy_get_page(vars, force_integer: true)
      page_sym = vars[:page_sym] || DEFAULT[:page_sym]
      page     = Back.jsonapi?(params, vars) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end

    include Backend::Loader
  end
end
