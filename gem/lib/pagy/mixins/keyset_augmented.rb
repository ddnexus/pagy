# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

class Pagy
  module KeysetAugmentedMixin
    # Add keyset Augmented methods
    module BackendAddOn
      # Return Pagy::Keyset::Augmented object and paginated records
      def pagy_keyset_augmented_js(set, **vars)
        page = pagy_get_page(vars, force_integer: false) # allow nil
        if page.to_i.positive?    # numeric page -> no augmentation -> fallback
          return pagy_countless(set, **vars)
        elsif page.is_a?(String)  # augmented page param
          page_args = JSON.parse(B64.urlsafe_decode(page))
          # Restart the pagination from page 1 if the url has been requested from another browser
          vars[:page] = page_args if request.cookies['pagy'] == page_args.shift
        end

        vars[:limit] ||= pagy_get_limit(vars)
        pagy = Keyset::Augmented.new(set, **vars)
        [pagy, pagy.records]
      end
    end
    Backend.prepend BackendAddOn

    # Add the arguments for the client to the pagy_data for the *nav helpers
    module DataHelperOverride
      def pagy_data(pagy, *args)
        args.push([pagy.vars[:page_sym], pagy.update]) if pagy.is_a?(::Pagy::Keyset::Augmented) && args[0].to_s.match(/^n/)
        super
      end
    end
    Frontend.prepend DataHelperOverride
  end
end
