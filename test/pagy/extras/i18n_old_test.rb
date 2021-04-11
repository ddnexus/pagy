# encoding: utf-8
# frozen_string_literal: true

require 'i18n'

# mimic old i18n version in order to trigger a different definition
# of course it raises a couple of warnings, but with cover the definition
# with the same 118n gem version
::I18n::VERSION = '1.5.9'

require_relative '../../test_helper'
require 'pagy/extras/i18n'
require_relative 'i18n_test'
