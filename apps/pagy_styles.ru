# frozen_string_literal: true

# Self-contained sinatra app to play with the pagy styles in the browser

# INSTALL
# Option a)
# Download and run this file from your local copy
# Ensure rack is installed (or `gem install rack`)

# Option b)
# Clone pagy and run this file from the apps dir in the repo
# git clone --depth 1 https://github.com/ddnexus/pagy

# USAGE
#    rackup -o 0.0.0.0 -p 8080 pagy_styles.ru

# DEV USAGE (with automatic app reload if you edit it)
# Ensure rerun is installed (or `gem install rerun`)
#    rerun -- rackup -o 0.0.0.0 -p 8080 pagy_styles.ru

# Available at http://0.0.0.0:8080

def run_from_repo?
  File.readlines('../pagy.manifest') { |line| File.exist?("../#{line}") }
rescue StandardError
  false
end

if run_from_repo?
  require 'bundler'
  Bundler.require(:default, :apps)
  require 'oj' # require false in Gemfile
  $LOAD_PATH.unshift File.expand_path('../lib', __dir__)
  require 'pagy'
else
  require 'bundler/inline'
  gemfile true do
    source 'https://rubygems.org'
    gem 'oj'
    gem 'pagy'
    gem 'puma'
    gem 'rack'
    gem 'rackup'
    gem 'rouge'
    gem 'sinatra'
    gem 'sinatra-contrib'
  end
end

# pagy initializer
STYLES = { pagy:        { extra: 'navs', prefix: '' },
           bootstrap:   {},
           bulma:       {},
           foundation:  {},
           materialize: {},
           semantic:    {},
           tailwind:    { extra: 'navs', prefix: '' },
           uikit:       {} }.freeze

STYLES.each_key do |style|
  require "pagy/extras/#{STYLES[style][:extra] || style}"
end
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::DEFAULT[:size]       = [1, 4, 4, 1]  # old size default
Pagy::DEFAULT[:trim_extra] = false         # opt-in trim

# sinatra setup
require 'sinatra/base'

# sinatra application
class PagyStyles < Sinatra::Base
  configure do
    enable :inline_templates
  end

  include Pagy::Backend

  get '/' do
    redirect '/pagy'
  end

  get('/javascripts/:file') do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', params['file'])
  end

  get('/stylesheets/:file') do
    content_type 'text/css'
    send_file Pagy.root.join('stylesheets', params['file'])
  end

  # one route/action per style
  STYLES.each_key do |style|
    prefix = STYLES[style][:prefix] || "#{style}_"

    get("/#{style}/?:trim?") do
      collection = MockCollection.new
      @pagy, @records = pagy(collection, trim_extra: params['trim'])

      erb :helpers, locals: { style:, prefix: }
    end
  end

  helpers do
    include Pagy::Frontend

    def style_menu
      html = +%(<div id="style-menu"> )
      STYLES.each_key { |style| html << %(<a href="/#{style}">#{style}</a>) }
      html << %(</div>)
    end

    def highlight(html)
      formatted = Formatter.new.format(html)
      lexer     = Rouge::Lexers::HTML.new
      formatter = Rouge::Formatters::HTMLInline.new('monokai')
      %(<details><summary>Served HTML (pretty formatted)</summary><pre>\n#{
         formatter.format(lexer.lex(formatted))
      }</pre></details>)
    end
  end
end

# Cheap pagy formatter for helpers output
class Formatter
  INDENT     = '  '
  TEXT_SPACE = "\u00B7"
  TEXT       = /^([^<>]+)(.*)/
  UNPAIRED   = /^(<(input).*?>)(.*)/
  PAIRED     = %r{^(<(nav|div|span|p|a|b|label|ul|li).*?>)(.*?)(</\2>)(.*)}
  WRAPPER    = /<.*?>/
  DATA_PAGY  = /(data-pagy="([^"]+)")/

  def initialize
    @formatted = +''
  end

  def format(input, level = 0)
    process(input, level)
    @formatted
  end

  private

  def process(input, level)
    push = ->(content) { @formatted << ((INDENT * level) + content + "\n") }
    rest = nil
    if (match = input.match(TEXT))
      text, rest = match.captures
      push.(text.gsub(' ', TEXT_SPACE))
    elsif (match = input.match(UNPAIRED))
      tag, _name, rest = match.captures
      push.(tag)
    elsif (match = input.match(PAIRED))
      tag_start, name, block, tag_end, rest = match.captures
      ## Handle incomplete same-tag nesting
      while block.scan(/<#{name}.*?>/).size > block.scan(tag_end).size
        more, rest = rest.split(tag_end, 2)
        block << tag_end << more
      end
      if name.eql?('a')
        tag_start.gsub!(/[\s]+/, ' ')
        tag_start.gsub!(/[\s]>/, '>')
      end
      if (match = tag_start.match(DATA_PAGY))
        search, data = match.captures
        formatted = data.scan(/.{1,76}/).join("\n")
        replace = %(\n#{INDENT * (level + 1)}data-pagy="#{formatted}")
        tag_start.sub!(search, replace)
      end
      if block.match(WRAPPER)
        push.(tag_start)
        process(block, level + 1)
        push.(tag_end)
      else
        push.(tag_start + block + tag_end)
      end
    end
    process(rest, level) if rest
  end
end

# Simple array-based collection that acts as a standard DB collection.
class MockCollection < Array
  def initialize(arr = Array(1..1000))
    super
    @collection = clone
  end

  def offset(value)
    @collection = self[value..]
    self
  end

  def limit(value)
    @collection[0, value]
  end

  def count(*)
    size
  end
end

run PagyStyles

__END__

@@ layout
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Pagy Styles</title>
    <script src="<%= %(/javascripts/#{"pagy#{'-dev' if ENV['DEBUG']}.js"}) %>"></script>
    <script>
      window.addEventListener("load", Pagy.init);
    </script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%= erb :"#{style}_head" if defined?(style) %>
    <style type="text/css">
      @media screen { html, body {
        font-size: 1rem;
        line-height: 1.2s;
        padding: 0;
        margin: 0;
      } }
      body {
        background: white !important;
        margin: 0 !important;
        font-family: sans-serif !important;
      }
      h1, h4 {
        font-size: 1.8rem !important;
        font-weight: 600 !important;
        margin-top: 1rem !important;
        margin-bottom: 0.5rem !important;
        line-height: 1.5 !important;
        color: rgb(90 90 90)  !important;
      }
      h4 {
        font-size: 1.05rem !important;
        margin-top: 1.5rem !important;
      }
      summary {
        font-size: .8rem;
        color: gray;
        margin-top: .5rem;
        font-style: italic;
        cursor: pointer;
      }
      pre, pre code {
        display: block;
        margin-top: .3rem;
        margin-bottom: 1rem;
        font-size: .8rem !important;
        line-heigth: 1rem !important;
        color: white;
        background-color: rgb(30 30 30);
        padding: 1rem;
        overflow: auto;
      }
     .content {
        padding: 0 1.5rem 2rem !important;
      }

      #style-menu {
        flex;
        font-family: sans-serif;
        font-size: 1.1rem;
        line-height: 1.5rem;
        white-space: nowrap;
        color: white;
        background-color: gray;
        padding: .2rem 1.5rem;
      }
      #style-menu > :not([hidden]) ~ :not([hidden]) {
        --space-reverse: 0;
        margin-right: calc(0.5rem * var(--space-reverse));
        margin-left: calc(0.5rem * calc(1 - var(--space-reverse)));
      }
      #style-menu a {
        color: inherit;
        text-decoration: none;
      }
    </style>
  </head>
  <body>
    <!-- each different class used by each style -->
    <%= style_menu %>
    <div class="content">
      <%= yield %>
    <div>
  </body>
</html>


@@ pagy_head
<!-- copy and paste the pagy style in order to edit it -->
<link rel="stylesheet" href="/stylesheets/pagy.css">

@@ bootstrap_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

@@ bulma_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">

@@ foundation_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/foundation-sites@6.8.1/dist/css/foundation.min.css" crossorigin="anonymous">

@@ materialize_head
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">

@@ semantic_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/semantic-ui@2.5.0/dist/semantic.min.css"><script
  src="https://code.jquery.com/jquery-3.1.1.min.js"
  integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
  crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/semantic-ui@2.5.0/dist/semantic.min.js"></script>

@@ tailwind_head
<script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
<!-- copy and paste the pagy.tailwind style in order to edit it -->
<style type="text/tailwindcss">
  <%= Pagy.root.join('stylesheets', 'pagy.tailwind.scss').read %>
</style>

@@ uikit_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/uikit@3.18.3/dist/css/uikit.min.css" />
<script src="https://cdn.jsdelivr.net/npm/uikit@3.18.3/dist/js/uikit.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/uikit@3.18.3/dist/js/uikit-icons.min.js"></script>

@@ helpers
<h1><%= style %></h1>

<h4>Collection</h4>
<p>@records: <%= @records.join(',') %></p>

<div class="helpers-container">
  <h4>pagy_<%= prefix %>nav</h4>
  <%= html = send(:"pagy_#{prefix}nav", @pagy, pagy_id: 'nav', nav_aria_label: 'Pages nav') %>
  <%= highlight(html) %>

  <h4>pagy_<%= prefix %>nav_js</h4>
  <%= html = send(:"pagy_#{prefix}nav_js", @pagy, pagy_id: 'nav-js', nav_aria_label: 'Pages nav_js') %>
  <%= highlight(html) %>

  <h4>pagy_<%= prefix %>nav_js (responsive)</h4>
  <%= html = send(:"pagy_#{prefix}nav_js", @pagy, pagy_id: 'nav-js-responsive',
       nav_aria_label: 'Pages nav_js_responsive',
       steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
  <%= highlight(html) %>

  <h4>pagy_<%= prefix %>combo_nav_js</h4>
  <%= html = send(:"pagy_#{prefix}combo_nav_js", @pagy, pagy_id: 'combo-nav-js', nav_aria_label: 'Pages combo_nav_js') %>
  <%= highlight(html) %>

  <h4>pagy_items_selector_js</h4>
  <%= html = pagy_items_selector_js(@pagy, pagy_id: 'items-selector-js') %>
  <%= highlight(html) %>

  <h4>pagy_info</h4>
  <%= html = pagy_info(@pagy, pagy_id: 'pagy-info') %>
  <%= highlight(html) %>
</div>
