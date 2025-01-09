# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/loader'

# Top superclass: it should define only what's common to all the subclasses
class Pagy
  autoload :Backend,            'pagy/backend'
  autoload :Frontend,           'pagy/frontend'
  autoload :I18n,               'pagy/i18n'
  autoload :UISupport,          'pagy/ui_support'
  autoload :Offset,             'pagy/offset'
  autoload :Keyset,             'pagy/keyset'
  autoload :ElasticsearchRails, 'pagy/mixins/elasticsearch_rails'
  autoload :Meilisearch,        'pagy/mixins/meilisearch'
  autoload :Searchkick,         'pagy/mixins/searchkick'
  autoload :Console,            'pagy/console'

  VERSION     = '9.3.3'
  PAGE_TOKEN  = 'P '
  LABEL_TOKEN = 'L'
  LIMIT_TOKEN = 'L '
  A_TAG       = '<a href="#" style="display: none;">#</a>'
  DEFAULT     = { limit: 20, # rubocop:disable Style/MutableConstant
                  page_sym: :page }
  # Gem root pathname to get the path of Pagy files stylesheets, javascripts, apps, locales, etc.
  def self.root
    @root ||= Pathname.new(__dir__).parent.freeze
  end

  attr_reader :page, :prev, :next, :in, :limit, :vars, :last

  alias pages last
  def self.predict_last? = true

  # Validates and assign the passed vars: var must be present and value.to_i must be >= to min
  def assign_and_check(name_min)
    name_min.each do |name, min|
      raise VariableError.new(self, name, ">= #{min}", @vars[name]) \
      unless @vars[name]&.respond_to?(:to_i) && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
    end
  end

  # Assign @limit (overridden by the gearbox extra)
  def assign_limit
    assign_and_check(limit: 1)
  end

  # Assign @vars
  def assign_vars(vars)
    cclass  = self.class
    default = cclass::DEFAULT
    while cclass != Pagy
      cclass  = cclass.superclass
      default = cclass::DEFAULT.merge(default)
    end
    @vars = { **default, **vars.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') } }
  end
end

require_relative 'pagy/exceptions'
