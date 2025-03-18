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

VERSION = '10.0.0'

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
          bootstrap: { style: :bootstrap, classes: 'pagination pagination-sm' },
          bulma:     { style: :bulma, classes: 'pagination is-small' },
          tailwind:  { css_anchor: 'pagy-tailwind-css' } }.freeze

# Sinatra setup
require 'sinatra/base'

# Pagy init
Pagy.options[:client_max_limit] = 100

# Sinatra application
class PagyDemo < Sinatra::Base
  include Pagy::Method

  get '/' do
    redirect '/pagy'
  end

  get '/template' do
    collection      = MockCollection.new
    @pagy, @records = pagy(:offset, collection)

    erb :template, locals: { pagy: @pagy, name: 'template', css_anchor: 'pagy-scss' }
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
      erb :helpers, locals: { name:,
                              style: value[:style],
                              classes: value[:classes],
                              css_anchor: value[:css_anchor] }
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
          *,
          *::before,
          *::after {
            box-sizing: border-box;
          }
          input[type="range"] {
            all: revert;
          }
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
          .main-content {
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
          .pagy, .pagy-bootstrap, .pagy-bulma {
            padding: .5em;
            margin: .3em 0;
            width: fit-content;
            box-shadow: 5px 5px 10px 0px rgba(0,0,0,0.2);
          }
          .pagy-bootstrap .pagination {
            margin: 0;
          }

          #control-container {
            background-color: #E8E8E8;
            border: 1px solid gray;
            padding: 20px;
            display: table; /* Or display: inline-block; */
          }
          #pagy-control-box {
            display: grid;
            grid-template-columns: 150px 200px 50px;
            grid-row-gap: 5px;
            grid-column-gap: 5px;
            padding-left: 5px;
          }

          #pagy-control-box label {
            grid-column: 1;
            text-align: right;
            padding-right: 5px;
          }

          #pagy-control-box input[type="range"] {
            grid-column: 2;
            all: revert; /* Restore user-agent styles for range inputs */
          }

          #pagy-control-box input[type="color"] {
            grid-column: 2;
            all: revert; /* Restore user-agent styles for range inputs */
          }

          #pagy-control-box span {
            text-align: left;
            grid-column: 3;
          }

          #pagy-control-box h2 {
            grid-column: 1 / -1;
          }

          #reset-style-button {
            all: revert;
            display: block;
            margin-top: 10px;
            justify-self: end;
          }

          #css-variables-display {
            width: 100%;
            grid-column: 2 / -1;
            grid-row: 6;
            height: 130px;
            resize: vertical;
          }

          #pagy-control-box label[for="css-variables-display"] {
            grid-column: 1;
            grid-row: 6;
            align-self: start;
          }
          #reset-style-button {
            all: revert;
            display: block;
            margin-top: 10px;
            padding: .5em 2em;
            justify-self: end;
          }
          /* INTERNAL USE: screenshot masking start
          .pagy, .pagy-bootstrap, .pagy-bulma {
            background-color: black !important;
          }
          .pagy *:not(.gap) {
            background-color: white !important;
          }
          .pagy *, .pagy-bootstrap *,
          .pagy-bulma a,
          .pagy-bulma label,
          .pagy-bulma .pagination-ellipsis  {
            color: white !important;
          }
          .pagy-bootstrap .page-item .page-link,
          .pagy-bulma li.pagination-link,
          .pagy-bulma input,
          .pagy-bulma a, .pagy-bulma a.pagination-previous, .pagy-bulma a.pagination-next {
            border-color: white !important;
            background-color: white !important;
            opacity: 1;
          }
          /* INTERNAL USE: screenshot masking end */

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
        <div class="main-content">
          <%= yield %>
        </div>
      </body>
      </html>
    ERB
  end

  template :template_head do
    '<link rel="stylesheet" href="/stylesheet/pagy.css">'
  end

  template :pagy_head do
    <<~ERB
      <link rel="stylesheet" href="/stylesheet/pagy.css">
      <style id="app-pagy-style">
      /* dynamically overridden by js */
      </style>

      <script>
        function getDefaultCssVariableValue(className, variableName) {
          const element = document.querySelector('.' + className);
          if (element) {
            const style = getComputedStyle(element);
            return style.getPropertyValue(variableName).trim();
          }
          return null;
        }

        function initializePagyDemo() {
          const hueInput = document.getElementById('hue');
          const saturationInput = document.getElementById('saturation');
          const lightnessInput = document.getElementById('lightness');
          const hueValue = document.getElementById('hue-value');
          const saturationValue = document.getElementById('saturation-value');
          const lightnessValue = document.getElementById('lightness-value');
          const bgColorInput = document.getElementById('bg-color');
          const opacityInput = document.getElementById('opacity');
          const opacityValue = document.getElementById('opacity-value');
          const appPagyStyle = document.getElementById('app-pagy-style');
          const pagyElements = document.querySelectorAll('.pagy');
          const resetStyleButton = document.getElementById('reset-style-button');
          const cssVariablesDisplay = document.getElementById('css-variables-display');

          function resetStyles() {
            document.cookie = "pagy_hue=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            document.cookie = "pagy_saturation=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            document.cookie = "pagy_lightness=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            document.cookie = "pagy_bgColor=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            document.cookie = "pagy_opacity=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            window.location.reload();
          }

          function getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
          }

          function setCookie(name, value) {
            document.cookie = `${name}=${value}; path=/`;
          }

          function updateControlVariables() {
            const cssVariablesString = `.pagy {\n` +
              `  --pagy-hue: ${hueInput.value};\n` +
              `  --pagy-saturation: ${saturationInput.value}%;\n` +
              `  --pagy-lightness: ${lightnessInput.value}%;\n` +
              `  --pagy-opacity: ${opacityInput.value};\n` +
              `}`;

            appPagyStyle.textContent = cssVariablesString;
            pagyElements.forEach(element => {
              element.style.backgroundColor = bgColorInput.value;
            });

            opacityValue.textContent = opacityInput.value;
            hueValue.textContent = hueInput.value;
            saturationValue.textContent = saturationInput.value + '%';
            lightnessValue.textContent = lightnessInput.value + '%';

            setCookie('pagy_hue', hueInput.value);
            setCookie('pagy_saturation', saturationInput.value);
            setCookie('pagy_lightness', lightnessInput.value);
            setCookie('pagy_bgColor', bgColorInput.value);
            setCookie('pagy_opacity', opacityInput.value);
            cssVariablesDisplay.value = cssVariablesString;
          }

          resetStyleButton.addEventListener('click', resetStyles);
          hueInput.addEventListener('input', updateControlVariables);
          saturationInput.addEventListener('input', updateControlVariables);
          lightnessInput.addEventListener('input', updateControlVariables);
          bgColorInput.addEventListener('input', updateControlVariables);
          opacityInput.addEventListener('input', updateControlVariables);

          const savedHue = getCookie('pagy_hue');
          const savedSaturation = getCookie('pagy_saturation');
          const savedLightness = getCookie('pagy_lightness');
          const savedBgColor = getCookie('pagy_bgColor');
          const savedOpacity = getCookie('pagy_opacity');

          if (savedHue) {
            hueInput.value = savedHue;
          } else {
              hueInput.value = getDefaultCssVariableValue('pagy', '--pagy-hue');
          }
          if (savedSaturation) {
            saturationInput.value = savedSaturation;
          } else {
              saturationInput.value = getDefaultCssVariableValue('pagy', '--pagy-saturation').replace('%','');
          }
          if (savedLightness) {
            lightnessInput.value = savedLightness;
          } else {
              lightnessInput.value = getDefaultCssVariableValue('pagy', '--pagy-lightness').replace('%','');
          }
          if (savedBgColor) {
            bgColorInput.value = savedBgColor;
          }
          if (savedOpacity) {
            opacityInput.value = savedOpacity;
          } else {
              opacityInput.value = getDefaultCssVariableValue('pagy', '--pagy-opacity');
          }

          updateControlVariables();
        }

        document.addEventListener('DOMContentLoaded', initializePagyDemo);
      </script>
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
        <p>Check the <u><i><b><a href="http://ddnexus.github.io/pagy/resources/stylesheet/#<%= css_anchor %>" target="blank"><%= css_anchor.gsub('-', '.') %></a></b></u></i>
        for details.</p>
      <% end %>
      </p>

      <% if name&.match(/pagy/) %>
         <div id="control-container">
          <b>Customize the Pagy Style</b>
          <hr>
          <div id="pagy-control-box">
            <h2>Pagy Variables</h2>
            <label for="hue">Pagy Hue:</label>
            <input type="range" id="hue" min="0" max="360">
            <span id="hue-value">215</span>
            <label for="saturation">Pagy Saturation:</label>
            <input type="range" id="saturation" min="0" max="100">
            <span id="saturation-value">65%</span>
            <label for="lightness">Pagy Lightness:</label>
            <input type="range" id="lightness" min="0" max="100">
            <span id="lightness-value">50%</span>
            <label for="opacity">Pagy Opacity:</label>
            <input type="range" id="opacity" min="0" max="1" step="0.01">
            <span id="opacity-value">1</span>
            <label for="css-variables-display">CSS Override:</label>
            <textarea id="css-variables-display" rows="5" cols="40" readonly></textarea>

            <h2>Visual Feedback</h2>
            <label for="bg-color">Page background:</label>
            <input type="color" id="bg-color" value="#ffffff">
          </div>
          <hr>
          <button id="reset-style-button">Reset Style</button>
        </div>
      <% end %>

      <h2>Collection</h2>
      <p id="records">@records: <%= @records.join(',') %></p>

      <h2>@pagy.series_nav<br/>
        <span class="notes">Small nav <code>{slots: 5, compact: true}</code></span>
      </h2>
      <%= html = @pagy.series_nav(style, classes:,
                                  id: 'small-nav',
                                  aria_label: 'Pages small-nav',
                                  slots: 5) %>
      <%= highlight(html) %>

      <h2>@pagy.series_nav<br/>
        <span class="notes">Series nav <code>{slots: 7}</code></span>
      </h2>
      <%= html = @pagy.series_nav(style, classes:,
                                  id: 'series-nav',
                                  aria_label: 'Pages series_nav') %>
      <%= highlight(html) %>

      <h2>@pagy.series_nav_js<br/>
        <span class="notes">Faster Series nav js <code>{slots: 7}</code></span>
      </h2>
      <%= html = @pagy.series_nav_js(style, classes:,
                                     id: 'series-nav-js',
                                     aria_label: 'Pages series_nav_js') %>
      <%= highlight(html) %>

      <h2>@pagy.series_nav_js<br/>
        <span class="notes">Responsive nav: <code>{steps: {0 => 5, 500 => 7, 750 => 9, 1000 => 11}}</code><br/>
        (Resize the window to see)
        </span>
      </h2>
      <%= html = @pagy.series_nav_js(style, classes:,
                                     id: 'series-nav-js-responsive',
                                     aria_label: 'Pages series_nav_js_responsive',
                                     steps:      { 0 => 5, 500 => 7, 750 => 9, 1000 => 11 }) %>
      <%= highlight(html) %>

      <h2>@pagy.input_nav_js</h2>
      <%= html = @pagy.input_nav_js(style, classes:,
                                    id: 'input-nav-js',
                                    aria_label: 'Pages inpup_nav_js') %>
      <%= highlight(html) %>

      <h2>@pagy.info_tag</h2>
      <%= html = @pagy.info_tag(id: 'pagy-info') %>
      <%= highlight(html) %>

      <% if name&.match(/pagy|tailwind/) %>
        <h2>@pagy.limit_tag_js</h2>
        <%= html = @pagy.limit_tag_js(id: 'limit-tag-js') %>
        <%= highlight(html) %>

        <h2>@pagy.previous_tag / @pagy.next_tag</h2>
        <%= html = '<nav class="pagy" id="prev-next" aria-label="Pagy prev-next">' << @pagy.previous_tag << @pagy.next_tag << '</nav>' %>
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
    <nav class="pagy series-nav" aria-label="Pages">
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
