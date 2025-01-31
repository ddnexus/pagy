# frozen_string_literal: true

require 'pathname'

# Top superclass: it defines only what's common to all the subclasses
class Pagy
  VERSION   = '9.3.3'
  ROOT      = Pathname.new(__dir__).parent.freeze
  PAGY_PATH = ROOT.join('lib/pagy').freeze

  autoload :Backend,            PAGY_PATH.join('backend')
  autoload :Frontend,           PAGY_PATH.join('frontend')
  autoload :I18n,               PAGY_PATH.join('i18n')
  autoload :Offset,             PAGY_PATH.join('offset')
  autoload :Calendar,           PAGY_PATH.join('calendar')
  autoload :Search,             PAGY_PATH.join('search')
  autoload :ElasticsearchRails, PAGY_PATH.join('search')
  autoload :Meilisearch,        PAGY_PATH.join('search')
  autoload :Searchkick,         PAGY_PATH.join('search')
  autoload :Keyset,             PAGY_PATH.join('keyset')
  autoload :Console,            PAGY_PATH.join('console')
  autoload :Config,             PAGY_PATH.join('config')

  DEFAULT     = { limit:     20,
                  limit_sym: :limit,
                  page_sym:  :page }.freeze
  PAGE_TOKEN  = 'P '
  LIMIT_TOKEN = 'L '
  LABEL_TOKEN = 'L'
  A_TAG       = '<a style="display: none;">#</a>'

  attr_reader :page, :count, :prev, :next, :in, :limit, :options, :last

  alias pages last

  # Validates and assign the passed options: var must be present and value.to_i must be >= to min
  def assign_and_check(name_min)
    name_min.each do |name, min|
      raise OptionError.new(self, name, ">= #{min}", @options[name]) \
            unless @options[name].respond_to?(:to_i) && instance_variable_set(:"@#{name}", @options[name].to_i) >= min
    end
  end

  def assign_options(**options)
    default = {}
    current = self.class
    begin
      default = current::DEFAULT.merge(default)
      current = current.superclass
    end until current == Object  # rubocop:disable Lint/Loop  # see https://github.com/rubocop/rubocop-performance/issues/362
    @options = default.merge(options.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') }).freeze
  end

  def page_for_url(page) = page
  def keynav?            = false
  def countless?         = false
  def calendar?          = false
end

require_relative 'pagy/exceptions'
