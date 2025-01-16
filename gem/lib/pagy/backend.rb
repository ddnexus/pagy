# frozen_string_literal: true

require_relative 'modules/url'
require_relative 'backend/loader'

class Pagy
  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_*` methods in your controller.
  module Backend
    private

    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end

    # Get the limit from request, vars or DEFAULT
    def pagy_get_limit(vars)
      if vars.key?(:limit_requestable) ? vars[:limit_requestable] : DEFAULT[:limit_requestable]
        limit = pagy_requested_limit(vars) || DEFAULT[:limit]
        [limit.to_i, (vars[:limit_max] ||= DEFAULT[:limit_max] || 100)].compact.min
      else
        DEFAULT[:limit]
      end
    end

    # Get the limit from the request
    def pagy_requested_limit(vars)
      limit_sym = vars[:limit_sym] || DEFAULT[:limit_sym]
      pagy_jsonapi?(vars) ? params[:page][limit_sym] : params[limit_sym]
    end

    # Get the page integer from the params
    def pagy_get_page(vars, force_integer: true)
      page_sym = vars[:page_sym] || DEFAULT[:page_sym]
      page     = pagy_jsonapi?(vars) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end

    def pagy_jsonapi?(vars)
      return false unless params[:page] && (vars.key?(:jsonapi) ? vars[:jsonapi] : DEFAULT[:jsonapi]) # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    include Backend::Loader
  end
end
