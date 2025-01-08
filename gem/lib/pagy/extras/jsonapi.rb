# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/jsonapi
# frozen_string_literal: true

require_relative '../url_helpers'
require_relative '../links_helper'

class Pagy
  DEFAULT[:jsonapi] = true

  # Add a specialized backend method compliant with JSON:API
  module JsonApiExtra
    # JsonApi :page param error
    class ReservedParamError < StandardError
      # Inform about the actual value
      def initialize(value)
        super("expected reserved :page param to be nil or Hash-like; got #{value.inspect}")
      end
    end

    # Module overriding Backend
    module BackendOverride
      private

      include UrlHelpers
      include LinksHelper

      # Return the jsonapi links
      alias pagy_jsonapi_links pagy_links

      # Should skip the jsonapi
      def pagy_skip_jsonapi?(vars)
        return true if vars[:jsonapi] == false || (vars[:jsonapi].nil? && DEFAULT[:jsonapi] == false)
        # check the reserved :page param
        raise ReservedParamError, params[:page] unless params[:page].respond_to?(:fetch) || params[:page].nil?
      end

      # Override the Backend method
      def pagy_get_page(vars, force_integer: true)
        return super if pagy_skip_jsonapi?(vars) || params[:page].nil?

        page = params[:page][vars[:page_sym] || DEFAULT[:page_sym]]
        force_integer ? (page || 1).to_i : page
      end
    end
    Backend.prepend BackendOverride

    # Module overriding LimitExtra
    module LimitExtraOverride
      private

      # Override the LimitExtra::Backend method
      def pagy_get_limit_param(vars)
        return super if pagy_skip_jsonapi?(vars)
        return unless params[:page]

        params[:page][vars[:limit_sym] || DEFAULT[:limit_sym]]
      end
    end
    # :nocov:
    LimitExtra::BackendAddOn.prepend LimitExtraOverride if defined?(::Pagy::LimitExtra::BackendAddOn)
    # :nocov:

    # Module overriding UrlHelper
    module UrlHelperOverride
      # Override UrlHelper method
      def pagy_set_query_params(page, vars, query_params)
        return super unless vars[:jsonapi]

        query_params['page'] ||= {}
        query_params['page'][vars[:page_sym].to_s]  = page
        query_params['page'][vars[:limit_sym].to_s] = vars[:limit] if vars[:limit_extra]
      end
    end
    Frontend.prepend UrlHelperOverride
  end
end
