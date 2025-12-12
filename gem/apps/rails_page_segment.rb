# frozen_string_literal: true

# ################# IMPORTANT WARNING #################
# Use this override ONLY if you strictly need to support the page param as a dynamic segment.
# (e.g. get '/comments(/:page)', to: 'comments#index').
#
# This setup forces Pagy to use the Rails `url_for` method, which is significantly
# slower (~20x) than Pagy's native URL generation.
# #####################################################

# 1. CONSTANT REDEFINITION
# We must replace Pagy's internal tokens.
# Why: Pagy marks its default tokens as "Escaped" to allow spaces into the URL template for safe interpolation.
# Since we are handing control back to Rails' standard QueryUtils, we need simple, URL-safe placeholders
# that Rails won't need to escape, to avoid mismatches between non-escaped and escaped tokens.
Pagy.send(:remove_const, :PAGE_TOKEN)
Pagy.send(:remove_const, :LIMIT_TOKEN)

Pagy::PAGE_TOKEN  = '___PAGY_PAGE___'
Pagy::LIMIT_TOKEN = '___PAGY_LIMIT___'

require 'pagy/toolbox/paginators/method'
require 'pagy/modules/abilities/linkable'

class Pagy
  # 2. REQUEST PARAMETERS
  # Why: Pagy defaults to Rack::Request to be framework agnostic.
  # To support dynamic segments (which are routing concepts, not query params),
  # we must switch to the Rails `request.params` method which includes path parameters.
  module RequestOverride
    def get_params(request)
      request.params
    end
  end
  Request.prepend RequestOverride

  # 3. CONTEXT INJECTION
  # Why: The Pagy object needs access to the Controller instance to call `url_for`.
  # We intercept the `pagy` method in the controller to inject `self` (the controller)
  # into the Pagy instance as `@context`.
  module MethodOverride
    def pagy(...)
      super.tap do |result|
        # result is [pagy_object, records]
        # We inject the controller (self) directly into the pagy object
        result[0].instance_variable_set(:@context, self)
      end
    end
  end
  Method.prepend MethodOverride

  # 4. URL GENERATION
  # Why: We override Pagy's optimized string interpolation with Rails' `url_for`.
  # We combine the current Rails parameters with Pagy's options and generate the URL.
  module LinkableOverride
    def compose_url(absolute, _path, params, fragment)
      params[:anchor]    = fragment if fragment
      params[:only_path] = !absolute

      # Call the Rails url_for method from the controller context
      @context.url_for(params)
    end
  end
  Linkable.prepend LinkableOverride
end

# USAGE with rails.ru

# Search and uncomment the following lines in the rails.ru app:
# require_relative 'rails_page_segment'  # Uncomment to test the rails_page_segment.rb override
# get '/comments(/:page)', to: 'comments#index'  # Uncomment to test the rails_page_segment.rb override
