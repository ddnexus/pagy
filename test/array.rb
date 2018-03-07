class Pagy
  module Array
    # extend any array object to get the page method (mostly useful for testing)
    module PageMethod
      # extended_array = (1..100).to_a.extend(Pagy::Array::PageMethods)
      # pagy, paged    = extended_array.page(4)
      def pagy(page, opts={})
        opts  = Opts.to_h                               # merge with the Pagy::Opts
                    .merge(opts)                        # use merge instead of **opts for ruby versions < 2.*
                    .merge(count: count, page: page)    # add count and page
        pagy  = Pagy.new(opts)                          # create the pagy object
        paged = self[pagy.offset, pagy.items]           # paged using #offset and #items from the pagy object
        return pagy, paged                              # return the pagy object and the page of items
      end

    end
  end
end
