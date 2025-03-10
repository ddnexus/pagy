# frozen_string_literal: true

# DESCRIPTION
#    Showcase all the helpers and styles
#
# DOC
#    https://ddnexus.github.io/pagy/playground/#3-demo-app
#
# BIN HELP
#    bundle exec pagy -h
#
# DEMO USAGE
#    bundle exec pagy demo
#
# DEV USAGE
#    bundle exec pagy clone demo
#    bundle exec pagy ./demo.ru
#
# URL
#    http://0.0.0.0:8000

VERSION = '9.3.4'

if VERSION != Pagy::VERSION
  Warning.warn("\n>>> WARNING! '#{File.basename(__FILE__)}-#{VERSION}' running with 'pagy-#{Pagy::VERSION}'! <<< \n\n")
end

# Bundle
require 'bundler/inline'
gemfile(!Pagy::ROOT.join('pagy.gemspec').exist?) do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'rouge'
  gem 'sinatra'
end

# pagy initializer
NAMES = { pagy:      { css_anchor: 'pagy-scss' },
          bootstrap: { style: :bootstrap },
          bulma:     { style: :bulma },
          tailwind:  { css_anchor: 'pagy-tailwind-css' } }.freeze

# Sinatra setup
require 'sinatra/base'

# Pagy init
Pagy.options[:requestable_limit] = 100

# Sinatra application
class PagyDemo < Sinatra::Base
  include Pagy::Method

  get '/' do
    redirect '/pagy'
  end

  get '/template' do
    collection      = MockCollection.new
    @pagy, @records = pagy(:offset, collection)

    erb :template, locals: { pagy: @pagy, name: 'pagy', css_anchor: 'pagy-scss' }
  end

  get('/javascript/:file') do
    format = params[:file].split('.').last
    if format == 'js'
      content_type 'application/javascript'
    elsif format == 'map'
      content_type 'application/json'
    end
    send_file Pagy::ROOT.join('javascript', params[:file])
  end

  get('/stylesheet/:file') do
    content_type 'text/css'
    send_file Pagy::ROOT.join('stylesheet', params[:file])
  end

  # One route/action per style
  NAMES.each do |name, value|
    get("/#{name}") do
      collection      = MockCollection.new
      @pagy, @records = pagy(:offset, collection)

      erb :helpers, locals: { name:, style: value[:style], css_anchor: value[:css_anchor] }
    end
  end

  helpers do
    def style_menu
      html = +%(<div id="style-menu"> )
      NAMES.each_key { |style| html << %(<a href="/#{style}">#{style}</a>) }
      html << %(<a href="/template">template</a>)
      html << %(</div>)
    end

    def highlight(html, format: :html)
      if format == :html
        html = html.gsub(/>[\s]*</, '><').strip # template single line no spaces around/between tags
        html = Formatter.new.format(html)
      end
      lexer     = Rouge::Lexers::ERB.new
      formatter = Rouge::Formatters::HTMLInline.new('monokai.sublime')
      summary   = { html: 'Served HTML (pretty formatted)', erb: 'ERB Template' }
      %(<details><summary>#{summary[format]}</summary><pre>\n#{
      formatter.format(lexer.lex(html))
      }</pre></details>)
    end
  end

  # Views
  template :layout do
    <<~'ERB'
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <title>Pagy Demo App</title>
        <script src="/javascript/pagy.js"></script>
        <script>
          window.addEventListener("load", Pagy.init);
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%= erb :"#{name}_head" if defined?(name) %>
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
          h1, h2 {
            font-size: 1.8rem !important;
            font-weight: 600 !important;
            margin-top: 1rem !important;
            margin-bottom: 0.7rem !important;
            line-height: 1.5 !important;
            color: rgb(90 90 90)  !important;
          }
          h2 {
            font-family: monospace;
            font-size: .9rem !important;
            margin-top: 1.6rem !important;
          }
          summary, .notes {
            font-size: .8rem;
            color: gray;
            margin-top: .6rem;
            font-style: italic;
            cursor: pointer;
          }
          .notes {
            font-family: sans-serif;
            font-weight: normal;
          }
          .notes code{
            background-color: #E8E8E8;
            padding: 0 0.3rem;
            font-style: normal;
            border-radius: 3px;
          }
          .description {
             margin: 1rem 0;
          }
          .description a {
            color: blue;
            text-decoration: underline;
          }
          pre, pre code {
            display: block;
            margin-top: .3rem;
            margin-bottom: 1rem;
            font-size: .8rem !important;
            line-height: 1rem !important;
            color: white;
            background-color: rgb(30 30 30);
            padding: 1rem;
            range_rescue: auto;
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
          /* Quick demo for overriding the element style attribute of certain pagy helpers
          .pagy input[style] {
            width: 5rem !important;
          }
          */
        </style>
      </head>
      <body>
        <!-- each different class used by each style -->
        <%= style_menu %>
        <div class="content">
          <%= yield %>
        </div>
      </body>
      </html>
    ERB
  end

  template :pagy_head do
    <<~ERB
      <!-- copy and paste the pagy style in order to edit it -->
      <link rel="stylesheet" href="/stylesheet/pagy.css">
    ERB
  end

  template :bootstrap_head do
    <<~ERB
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    ERB
  end

  template :bulma_head do
    <<~ERB
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    ERB
  end

  template :tailwind_head do
    <<~ERB
      <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
      <!-- copy and paste the pagy.tailwind style in order to edit it -->
      <style type="text/tailwindcss">
        <%= Pagy::ROOT.join('stylesheet/pagy.tailwind.css').read %>
      </style>
    ERB
  end

  template :helpers do
    <<~ERB
      <h1><%= name %></h1>

      <% if css_anchor %>
        and the <a href="http://ddnexus.github.io/pagy/docs/api/stylesheet/#<%= css_anchor %>" target="blank"><%= css_anchor.gsub('-', '.') %></a>
      <% end %>
      for details</p>

      <h2>Collection</h2>
      <p id="records">@records: <%= @records.join(',') %></p>

      <h2>pagy.nav_tag <span class="notes">Simple nav <code>size: 5</code></span></h2>
      <%= html = @pagy.nav_tag(style, id: 'simple-nav', aria_label: 'Pages simple-nav', size: 5) %>
      <%= highlight(html) %>

      <h2>pagy.nav_tag <span class="notes">Fast nav <code>size: 7</code></span></h2>
      <%= html = @pagy.nav_tag(style, id: 'nav', aria_label: 'Pages nav') %>
      <%= highlight(html) %>

      <h2>pagy.nav_js_tag <span class="notes">Fast nav <code>size: 7</code></span></h2>
      <%= html = @pagy.nav_js_tag(style, id: 'nav-js', aria_label: 'Pages nav_js') %>
      <%= highlight(html) %>

      <h2>pagy.nav_js_tag <span class="notes">Responsive nav <code>steps: {...}</code> (Resize the window to see)</span></h2>
      <%= html = @pagy.nav_js_tag(style, id: 'nav-js-responsive',
                              aria_label: 'Pages nav_js_responsive',
                              steps: { 0 => 5, 500 => 7, 750 => 9, 1000 => 11 }) %>
      <%= highlight(html) %>

      <h2>pagy.combo_nav_js_tag</h2>
      <%= html = @pagy.combo_nav_js_tag(style, id: 'combo-nav-js', aria_label: 'Pages combo_nav_js') %>
      <%= highlight(html) %>

      <h2>pagy.info_tag</h2>
      <%= html = @pagy.info_tag(id: 'pagy-info') %>
      <%= highlight(html) %>

      <% if name&.match(/pagy|tailwind/) %>
      <h2>pagy.limit_selector_js_tag</h2>
      <%= html = @pagy.limit_selector_js_tag(id: 'limit-selector-js') %>
      <%= highlight(html) %>

      <h2>pagy.previous_a_tag / pagy.next_a_tag</h2>
      <%= html = '<nav class="pagy" id="prev-next" aria-label="Pagy prev-next">' << @pagy.previous_a_tag << @pagy.next_a_tag << '</nav>' %>
      <%= highlight(html) %>
      <% end %>
    ERB
  end

  template :template do
    <<~ERB
      <h1>Pagy Template Demo</h1>

      <p class="description">
      See the <a href="https://ddnexus.github.io/pagy/docs/how-to/#using-your-pagination-templates">
      Custom Templates</a> documentation.
      </p>
      <h2>Collection</h2>
      <p id="records">@records: <%= @records.join(',') %></p>

      <h2>Rendered ERB template</h2>

      <%# We don't inline the template here, so we can highlight it more easily %>
      <%= html = ERB.new(TEMPLATE).result(binding) %>
      <%= highlight(TEMPLATE, format: :erb) %>
      <%= highlight(html) %>
    ERB
  end

  # Easier code highlighting
  TEMPLATE = <<~ERB
    <%# IMPORTANT: replace '<%=' with '<%==' if you run this in rails %>

    <%# The a variable below is set to a lambda that generates the a tag %>
    <%# Usage: anchor_tag = a_lambda.(page_number, text, classes: nil, aria_label: nil) %>
    <% a_lambda = pagy.send(:a_lambda) %>
    <nav class="pagy nav" aria-label="Pages">
      <%# Previous page link %>
      <% if pagy.previous %>
        <%= a_lambda.(pagy.previous, '&lt;', aria_label: 'Previous') %>
      <% else %>
        <a role="link" aria-disabled="true" aria-label="Previous">&lt;</a>
      <% end %>
      <%# Page links (series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]) %>
      <% pagy.send(:series).each do |item| %>
        <% if item.is_a?(Integer) %>
          <%= a_lambda.(item) %>
        <% elsif item.is_a?(String) %>
          <a role="link" aria-disabled="true" aria-current="page" class="current"><%= item %></a>
        <% elsif item == :gap %>
          <a role="link" aria-disabled="true" class="gap">&hellip;</a>
        <% end %>
      <% end %>
      <%# Next page link %>
      <% if pagy.next %>
        <%= a_lambda.(pagy.next, '&gt;', aria_label: 'Next') %>
      <% else %>
        <a role="link" aria-disabled="true" aria-label="Next">&lt;</a>
      <% end %>
    </nav>
  ERB
end

# Cheap pagy formatter for helpers output
class Formatter
  INDENT     = '  '
  TEXT_SPACE = "\u00B7"
  TEXT       = /^([^<>]+)(.*)/
  UNPAIRED   = /^(<(input|link).*?>)(.*)/
  PAIRED     = %r{^(<(head|nav|div|span|p|a|b|label|ul|li).*?>)(.*?)(</\2>)(.*)}
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
    push = ->(content) { @formatted << ((INDENT * level) << content << "\n") }
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
        block << (tag_end + more)
      end
      if (match = tag_start.match(DATA_PAGY))
        search, data = match.captures
        formatted    = data.scan(/.{1,76}/).join("\n")
        replace      = %(\n#{INDENT * (level + 1)}data-pagy="#{formatted}")
        tag_start.sub!(search, replace)
      end
      if block.match(WRAPPER)
        push.(tag_start)
        process(block, level + 1)
        push.(tag_end)
      else
        push.(tag_start << (block + tag_end))
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

run PagyDemo
