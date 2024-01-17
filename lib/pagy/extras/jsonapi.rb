# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/jsonapi
# frozen_string_literal: true

require 'pagy/url_helpers'

class Pagy # :nodoc:
  DEFAULT[:jsonapi] = true

  # Add a specialized backend method compliant with JSON:API
  module JsonApiExtra
    # JsonApi :page param error
    class ReservedParamError < StandardError
      # Inform about the actual value
      def initialize(value)
        super("expected reserved :page param to be nil or Hash; got #{value.inspect}")
      end
    end

    private

    include UrlHelpers

    # Return the jsonapi links
    def pagy_jsonapi_links(pagy, **opts)
      { first: pagy_url_for(pagy, 1,         **opts),
        last:  pagy_url_for(pagy, pagy.last, **opts),
        prev:  pagy_url_for(pagy, pagy.prev, **opts),
        next:  pagy_url_for(pagy, pagy.next, **opts) }
    end

    # Should skip the jsonapi
    def pagy_skip_jsonapi?(vars)
      return true if vars[:jsonapi] == false || (vars[:jsonapi].nil? && DEFAULT[:jsonapi] == false)
      # check the reserved :page param
      raise ReservedParamError, params[:page] unless params[:page].respond_to?(:fetch) || params[:page].nil?
    end

    # Override the Backend method
    def pagy_get_page(vars)
      return super if pagy_skip_jsonapi?(vars)
      return 1 if params[:page].nil?

      params[:page][vars[:page_param] || DEFAULT[:page_param]].to_i
    end

    # Override the ItemsExtra::Backend method
    def pagy_get_items_size(vars)
      return super if pagy_skip_jsonapi?(vars)
      return if params[:page].nil?

      params[:page][vars[:items_param] || DEFAULT[:items_param]]
    end

    # Override UrlHelper method
    def pagy_set_query_params(page, vars, params)
      return super unless vars[:jsonapi]

      params['page'] ||= {}
      params['page'][vars[:page_param].to_s]  = page
      params['page'][vars[:items_param].to_s] = vars[:items] if vars[:items_extra]
    end
  end
  Backend.prepend JsonApiExtra
  Frontend.prepend JsonApiExtra
end
