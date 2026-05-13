# frozen_string_literal: true

require 'pathname'

require_relative 'pagy/classes/exceptions'
require_relative 'pagy/modules/abilities/linkable'
require_relative 'pagy/modules/abilities/configurable'
require_relative 'pagy/toolbox/helpers/loaders'

# Top superclass
class Pagy
  VERSION     = '43.5.4'
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
  autoload :TypesenseRails,     path.join('classes/offset/search')
  autoload :Keyset,             path.join('classes/keyset/keyset')
  autoload :SyncTask,           path.join('tasks/sync')

  OPTIONS = {} # rubocop:disable Style/MutableConstant

  extend Configurable
  include Linkable
  include HelperLoader

  attr_reader :page, :next, :in, :limit, :options

  protected

  # Instance identity methods, overridden by the respective classes
  def offset?    = false
  def countless? = false
  def calendar?  = false
  def search?    = false
  def keyset?    = false
  def keynav?    = false

  # Validate presence and min value of options
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

  def validate_string_values(options)
    (options.keys & %i[page_key limit_key]).each do |key|
      raise OptionError.new(self, key, 'to be String', options[key]) \
      unless options[key].is_a?(String)
    end
  end

  # Merge all the DEFAULT constants of the class hierarchy with the options
  def assign_options(**options)
    @request = options.delete(:request) # internal object
    validate_string_values(options)

    default  = {}
    current  = self.class

    loop do
      default = current::DEFAULT.merge(default)
      current = current.superclass
      break if current == Object
    end

    clean_options = options.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') }
    @options      = default.merge!(clean_options).freeze
  end

  # Hook module for numeric UI helpers
  module NumericHelpers
    include NumericHelperLoader
  end
end

require_relative ENV['PAGY_NEXT'] == 'true' ? 'pagy/next' : 'pagy/deprecated'
