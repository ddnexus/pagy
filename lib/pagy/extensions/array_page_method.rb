class Pagy
  # extend array objects (specially useful for testing)
  module ArrayPageMethod

    # extended_array    = (1..100).to_a.extend(Pagy::ArrayPageMethod)
    # collection_page_4 = extended_array.page(4)
    # pagy_object       = collection_page_4.pagy
    def page(page, options={})
      pagy      = Pagy.new(self.count, page, options)        # create the paginator object
      paginated = self[pagy.offset, pagy.limit]              # paginated using #offset and #limit from the pagy object
      paginated.define_singleton_method(:pagy){ pagy }       # add the pagy object reader to the paginated collection for easy access
      paginated                                              # return the enhanced paginated collection and eventually the pagy object
    end

  end
end
