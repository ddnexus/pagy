# frozen_string_literal: true

require 'pathname'

# Top superclass: it defines only what's common to all the subclasses
class Pagy
  VERSION = '9.3.3'
  ROOT    = Pathname.new(__dir__).parent.freeze

  path = ROOT.join('lib/pagy').freeze
  autoload :Backend,  path.join('backend')
  autoload :Frontend, path.join('frontend')
  autoload :I18n,     path.join('modules/i18n')
  autoload :Offset,   path.join('offset')
  autoload :Keyset,   path.join('keyset')
  autoload :Console,  path.join('console')

  DEFAULT     = { limit:     20,    # rubocop:disable Style/MutableConstant
                  limit_sym: :limit,
                  page_sym:  :page }
  PAGE_TOKEN  = 'P '
  LABEL_TOKEN = 'L'
  LIMIT_TOKEN = 'L '
  A_TAG       = '<a href="#" style="display: none;">#</a>'

  # Used by the pagy links
  def self.predict_last? = true

  attr_reader :page, :prev, :next, :in, :limit, :vars, :last

  alias pages last

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
    default = { **cclass::DEFAULT }
    while cclass != Pagy
      cclass  = cclass.superclass
      default = { **cclass::DEFAULT, **default }
    end
    @vars = { **default, **vars.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') } }
  end

  def page_for_url(page) = page
end

require_relative 'pagy/exceptions'
