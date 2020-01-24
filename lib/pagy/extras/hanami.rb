class Pagy
  module Backend ; private
    def pagy_hanami(repository, vars={})
      pagy = Pagy.new(pagy_hanami_get_vars(repository, vars))
      return pagy, pagy_hanami_get_items(repository, pagy)
    end

    def pagy_hanami_get_items(repo, pagy)
      repo.page(pagy.offset, pagy.items)
    end

    def pagy_hanami_get_vars(repository, vars)
      count_method = vars.fetch(:count_method, :count)
      vars[:count] ||= repository.public_send(count_method)
      vars[:page]  ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end
  end

  module Helpers
    alias_method :pagy_url_for_without_hanami, :pagy_url_for
    def pagy_url_for_with_hanami(page, pagy)
      _pagy_data = send(self.class.pagy_data_exposure)
      options = { _pagy_data.vars[:page_param] => page }.merge(_pagy_data.vars[:params])
      routes.path(self.class.pagy_routes_path, options)
    end
    alias_method :pagy_url_for, :pagy_url_for_with_hanami
  end

  module Frontend
    module Hanami
      def self.included(base)
        base.send(:include, Pagy::Frontend)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def pagy_routes_path(path = nil)
          if path
            @_pagy_routes_path = path
          else
            @_pagy_routes_path
          end
        end

        def pagy_data_exposure(name = nil)
          if name
            @_pagy_data_exposure = name
          else
            @_pagy_data_exposure || :pagy_data
          end
        end
      end
    end
  end
end