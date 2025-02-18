# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/exceptions'
require_relative 'pagy/resources/features/linkable'
require_relative 'pagy/resources/loader'

# Top superclass: it defines only what's common to all the subclasses
class Pagy
  VERSION     = '9.3.3'
  ROOT        = Pathname.new(__dir__).parent.freeze
  PAGY_PATH   = ROOT.join('lib/pagy').freeze
  DEFAULT     = { limit: 20, limit_sym: :limit, page_sym: :page }.freeze
  PAGE_TOKEN  = 'P '
  LIMIT_TOKEN = 'L '
  LABEL_TOKEN = 'L'
  A_TAG       = '<a style="display: none;">#</a>'

  autoload :Paginators,         PAGY_PATH.join('paginators/paginators')
  autoload :I18n,               PAGY_PATH.join('resources/i18n/i18n')
  autoload :Calendar,           PAGY_PATH.join('calendar/calendar')
  autoload :Offset,             PAGY_PATH.join('offset/offset')
  autoload :Search,             PAGY_PATH.join('offset/search')
  autoload :ElasticsearchRails, PAGY_PATH.join('offset/search')
  autoload :Meilisearch,        PAGY_PATH.join('offset/search')
  autoload :Searchkick,         PAGY_PATH.join('offset/search')
  autoload :Keyset,             PAGY_PATH.join('keyset/keyset')
  autoload :Console,            PAGY_PATH.join('console')

  include Linkable
  include Loader

  def self.translate_with_the_slower_i18n_gem!
    send(:remove_const, :I18n)
    send(:const_set, :I18n, ::I18n)
    ::I18n.load_path += Dir[ROOT.join('locales/*.yml')]
  end

  # Ensure that the pagy javascript source files are installed and in sync with the Pagy::VERSION
  def self.sync_javascript_source(destination, *files)
    files = %w[pagy.mjs pagy.js pagy.js.map pagy.min.js] if files.empty?
    files.each { |file| FileUtils.cp(ROOT.join('javascripts', file), destination) }
  end

  attr_reader :page, :count, :previous, :next, :in, :limit, :options, :last

  protected

  # Define the hierarchical identity methods, overridden by the respective classes
  def offset?    = false
  def countless? = false
  def calendar?  = false
  def search?    = false
  def keyset?    = false
  def keynav?    = false

  # Validates and assign the passed options: var must be present and value.to_i must be >= to min
  def assign_and_check(name_min)
    name_min.each do |name, min|
      raise OptionError.new(self, name, ">= #{min}", @options[name]) \
            unless @options[name].respond_to?(:to_i) && instance_variable_set(:"@#{name}", @options[name].to_i) >= min
    end
  end

  # Merge all the DEFAULT constants of the class hierarchy with the options
  def assign_options(**options)
    @request = options.delete(:request)
    default  = {}
    current  = self.class
    begin
      default = current::DEFAULT.merge(default)
      current = current.superclass
    end until current == Object  # rubocop:disable Lint/Loop  -- see https://github.com/rubocop/rubocop-performance/issues/362
    @options = default.merge!(options.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') }).freeze
  end
end
