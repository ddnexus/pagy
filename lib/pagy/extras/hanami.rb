class Pagy
  module Hanami
    module RepositoryIntegration
      def page(offset, size)
        root.offset(offset).limit(size).to_a
      end
    
      def count
        root.count
      end
    end
  end

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

  module Frontend
    module Hanami
      def self.included(base)
        base.send(:include, Pagy::Frontend)
        base.send(:include, InstanceMethods)
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

      module InstanceMethods
        def pagy_nav(*args)
          _raw super
        end
    
        def pagy_info(*args)
          _raw super
        end

        def pagy_url_for(page, pagy)
          _pagy_data = send(self.class.pagy_data_exposure)
          options = { _pagy_data.vars[:page_param] => page }.merge(_pagy_data.vars[:params])
          routes.path(self.class.pagy_routes_path, options)
        end
      end
    end
  end
end