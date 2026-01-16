# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/classes/exceptions'
require_relative 'pagy/modules/abilities/linkable'
require_relative 'pagy/modules/abilities/configurable'
require_relative 'pagy/toolbox/helpers/loader'

# Top superclass: it defines only what's common to all the subclasses
class Pagy
  VERSION     = '43.2.6'
  ROOT        = Pathname.new(__dir__).parent.freeze
  DEFAULT     = { limit: 20, limit_key: 'limit', page_key: 'page' }.freeze
  PAGE_TOKEN  = EscapedValue.new('P ')
  LIMIT_TOKEN = EscapedValue.new('L ')
  LABEL_TOKEN = 'L'
  A_TAG       = '<a style="display: none;">#</a>'

  path = Pathname.new(__FILE__).sub_ext('')
  autoload :Method,             path.join('toolbox/paginators/method')
  autoload :I18n,               path.join('modules/i18n/i18n')
  autoload :Console,            path.join('modules/console')
  autoload :Calendar,           path.join('classes/calendar/calendar')
  autoload :Offset,             path.join('classes/offset/offset')
  autoload :Search,             path.join('classes/offset/search')
  autoload :ElasticsearchRails, path.join('classes/offset/search')
  autoload :Meilisearch,        path.join('classes/offset/search')
  autoload :Searchkick,         path.join('classes/offset/search')
  autoload :Keyset,             path.join('classes/keyset/keyset')

  def self.options = @options ||= {}

  extend Configurable
  include Linkable
  include Loader

  attr_reader :page, :next, :in, :limit, :options

  protected

  # Define the hierarchical identity methods, overridden by the respective classes
  def offset?    = false
  def countless? = false
  def calendar?  = false
  def search?    = false
  def keyset?    = false
  def keynav?    = false

  # Validates and assign the passed options: they must be present and value.to_i must be >= min
  def assign_and_check(name_min)
    name_min.each do |name, min|
      value = @options[name]

      if value.respond_to?(:to_i) && (integer = value.to_i) >= min
        instance_variable_set(:"@#{name}", integer)
      else
        raise OptionError.new(self, name, ">= #{min}", value)
      end
    end
  end

  # Merge all the DEFAULT constants of the class hierarchy with the options
  def assign_options(**options)
    @request = options.delete(:request) # internal object
    default  = {}
    current  = self.class

    begin
      default = current::DEFAULT.merge(default)
      current = current.superclass
    end until current == Object  # rubocop:disable Lint/Loop  -- see https://github.com/rubocop/rubocop-performance/issues/362

    clean_options = options.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') }
    @options      = default.merge!(clean_options).freeze
  end
end
