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
          tailwind:  { css_anchor: 'pagy-tailwind-css' },
          bootstrap: { style: :bootstrap, classes: 'pagination pagination-sm' },
          bulma:     { style: :bulma, classes: 'pagination is-small' } }.freeze

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
      erb :page, locals: { name:,
                           style: value[:style],
                           classes: value[:classes],
                           css_anchor: value[:css_anchor] }
    end
  end

  helpers do
    def style_menu
      html = +%(<div id="style-menu"> )
      NAMES.each_key do |style|
        name    = style.to_s
        name[0] = name[0].capitalize
        html << %(<a href="/#{style}">#{name}</a>)
      end
      html << %(<a href="/template">Template</a>)
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

  TWEAKER_SCRIPT = <<~HTML
    <script>
      function createDynamicStyleTag() {
        const dynamicStyle = document.createElement('style');
        dynamicStyle.id = 'app-pagy-style';
        document.head.appendChild(dynamicStyle);
      }

      function getDefaultValue(variableName) {
        const element = document.querySelector('.pagy');
        if (element) {
          const style = getComputedStyle(element);
          return style.getPropertyValue(variableName).trim();
        }
        return null;
      }

      function initializePagyDemo() {
        createDynamicStyleTag();

        const hueInput = document.getElementById('hue');
        const saturationInput = document.getElementById('saturation');
        const lightnessInput = document.getElementById('lightness');
        const opacityInput = document.getElementById('opacity');
        const appPagyStyle = document.getElementById('app-pagy-style');
        const pagyElements = document.querySelectorAll('.pagy');
        const resetButton = document.getElementById('reset-button');
        const overrideDisplay = document.getElementById('override');
        const spacingInput = document.getElementById('spacing');
        const roundingInput = document.getElementById('rounding');
        const paddingInput = document.getElementById('padding');
        const fontSizeInput = document.getElementById('font-size');
        const lineHeightInput = document.getElementById('line-height');
        const brightnessInput = document.getElementById('brightness');
        const fontWeightInput = document.getElementById('font-weight');
        const borderWidthInput = document.getElementById('border-width');

        function resetCssVariables() {
          const cookieNames = [
            "pagy_brightness",
            "pagy_hue",
            "pagy_saturation",
            "pagy_lightness",
            "pagy_opacity",
            "pagy_spacing",
            "pagy_rounding",
            "pagy_padding",
            "pagy_line_height",
            "pagy_font_size",
            "pagy_font_weight",
            "pagy_border_width" ];
          cookieNames.forEach((name) => {
            document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
          });
          window.location.reload();
        }

        function getCookie(name) {
          const value = `; ${document.cookie}`;
          const parts = value.split(`; ${name}=`);
          if (parts.length === 2) {
            return parts.pop().split(';').shift();
          }
        }

        function setCookie(name, value) {
          document.cookie = `${name}=${value}; path=/`;
        }

        function updateCSSVariables() {
          const override =
            `.pagy {\n` +
            `  --B: ${brightnessInput.value};\n` +
            `  --H: ${hueInput.value};\n` +
            `  --S: ${saturationInput.value};\n` +
            `  --L: ${lightnessInput.value};\n` +
            `  --opacity: ${opacityInput.value};\n` +
            `  --spacing: ${spacingInput.value}rem;\n` +
            `  --rounding: ${roundingInput.value}rem;\n` +
            `  --padding: ${paddingInput.value}rem;\n` +
            `  --line-height: ${lineHeightInput.value}rem;\n` +
            `  --font-size: ${fontSizeInput.value}rem;\n` +
            `  --font-weight: ${fontWeightInput.value};\n` +
            `  --border-width: ${borderWidthInput.value}rem;\n` +
            `}`;

          appPagyStyle.textContent = override;

          // Update bgColor based on brightness
          let backdrop = brightnessInput.value === '-1' ? '#000000' : '#ffffff';

          pagyElements.forEach((element) => {
            element.style.backgroundColor = backdrop;
          });

          setCookie('pagy_hue', hueInput.value);
          setCookie('pagy_saturation', saturationInput.value);
          setCookie('pagy_lightness', lightnessInput.value);
          setCookie('pagy_brightness', brightnessInput.value);
          setCookie('pagy_opacity', opacityInput.value);
          setCookie('pagy_spacing', spacingInput.value);
          setCookie('pagy_rounding', roundingInput.value);
          setCookie('pagy_padding', paddingInput.value);
          setCookie('pagy_font_size', fontSizeInput.value);
          setCookie('pagy_line_height', lineHeightInput.value);
          setCookie('pagy_font_weight', fontWeightInput.value);
          setCookie('pagy_border_width', borderWidthInput.value);
          overrideDisplay.value = override;
        }

        brightnessInput.addEventListener('input', updateCSSVariables);
        hueInput.addEventListener('input', updateCSSVariables);
        saturationInput.addEventListener('input', updateCSSVariables);
        lightnessInput.addEventListener('input', updateCSSVariables);
        opacityInput.addEventListener('input', updateCSSVariables);
        spacingInput.addEventListener('input', updateCSSVariables);
        roundingInput.addEventListener('input', updateCSSVariables);
        paddingInput.addEventListener('input', updateCSSVariables);
        fontSizeInput.addEventListener('input', updateCSSVariables);
        lineHeightInput.addEventListener('input', updateCSSVariables);
        fontWeightInput.addEventListener('input', updateCSSVariables);
        borderWidthInput.addEventListener('input', updateCSSVariables);
        resetButton.addEventListener('click', resetCssVariables);

        const savedBrightness = getCookie('pagy_brightness');
        const savedHue = getCookie('pagy_hue');
        const savedSaturation = getCookie('pagy_saturation');
        const savedLightness = getCookie('pagy_lightness');
        const savedOpacity = getCookie('pagy_opacity');
        const savedSpacing = getCookie('pagy_spacing');
        const savedRounding = getCookie('pagy_rounding');
        const savedPadding = getCookie('pagy_padding');
        const savedFontSize = getCookie('pagy_font_size');
        const savedLineHeight = getCookie('pagy_line_height');
        const savedFontWeight = getCookie('pagy_font_weight');
        const savedBorderWidth = getCookie('pagy_border_width');

        brightnessInput.value = savedBrightness ?? getDefaultValue('--B');
        hueInput.value = savedHue ?? getDefaultValue('--H');
        saturationInput.value = savedSaturation ?? getDefaultValue('--S');
        lightnessInput.value = savedLightness ?? getDefaultValue('--L');
        opacityInput.value = savedOpacity ?? getDefaultValue('--opacity');
        spacingInput.value = savedSpacing ?? getDefaultValue('--spacing').replace('rem', '');
        roundingInput.value = savedRounding ?? getDefaultValue('--rounding').replace('rem', '');
        paddingInput.value = savedPadding ?? getDefaultValue('--padding').replace('rem', '');
        fontSizeInput.value = savedFontSize ?? getDefaultValue('--font-size').replace('rem', '');
        lineHeightInput.value = savedLineHeight ?? getDefaultValue('--line-height').replace('rem', '');
        fontWeightInput.value = savedFontWeight ?? getDefaultValue('--font-weight');
        borderWidthInput.value = savedBorderWidth ?? getDefaultValue('--border-width').replace('rem', '');

        // Update backdrop based on brightness during initialization
        let initialBgColor = brightnessInput.value === '-1' ? '#000000' : '#ffffff';

        pagyElements.forEach((element) => {
          element.style.backgroundColor = initialBgColor;
        });

        updateCSSVariables();
      }
      document.addEventListener('DOMContentLoaded', initializePagyDemo);
    </script>
  HTML

  TWEAKER_STYLE = <<~HTML
    <style>
      @media (max-width: 900px) {
        #main-container {
          flex-direction: column;
        }
        #top-hr {
          display: none;
        }
      }
      #main-container {
        display: flex;
        flex-wrap: wrap;
      }
      #tweaker {
        all: revert;
        border: 1px solid white;
        padding: 20px;
        display: table;
        margin-top: 8px;
        margin-right: 40px;
        width: 400px;
        align-self: flex-start; /* Prevents the left panel from stretching to match the right panel's height */
        flex-shrink: 0; /* Prevents the left panel from shrinking */
        box-sizing: border-box;
        background-color: rgba(255,255,255,.5);
        box-shadow: 8px 8px 18px 0px rgba(0,0,0,0.2);
      }
      #content {
        box-sizing: border-box;
        flex: 1;
        overflow: hidden;
        width: 100%;
        min-width: 0;
      }
      #tweaker-grid {
        all: revert;
        display: grid;
        grid-template-columns: auto auto; /* Or your desired columns */
        grid-row-gap: 3px;
        grid-column-gap: 5px;
        line-height: 1rem;
        width: 100%;
      }
      #tweaker-grid label {
        grid-column: 1;
        text-align: right;
        padding-right: 5px;
        white-space: nowrap;
      }

      #brightness {
        all: revert;
        margin: 0 2px;
      }
      #override {
        all: revert;
        font-family: monospace;
        font-size: .8rem;
        line-height: 1.25;
        height: 235px;
        resize: vertical;
        margin: 2px;
      }
      #reset-button {
        all: revert;
        display: block;
        margin-top: 10px;
        margin-right: 3px;
        padding: .5em 2em;
        justify-self: end;
      }
    </style>
  HTML

  TWEAKER_HTML = <<~HTML
    <div id="tweaker">
      <b>CSS Tweaker</b>
      <hr>
      <div id="tweaker-grid">
        <label for="brightness">Brightness</label>
        <select id="brightness">
            <option value="1">Light</option>
            <option value="-1">Dark</option>
        </select>
        <label for="hue">Hue</label>
        <input type="range" id="hue" min="0" max="360">
        <label for="saturation">Saturation</label>
        <input type="range" id="saturation" min="0" max="100">
        <label for="lightness">Lightness</label>
        <input type="range" id="lightness" min="0" max="100">
        <label for="opacity">Opacity</label>
        <input type="range" id="opacity" min="0" max="1" step="0.01">
        <label for="spacing">Spacing</label>
        <input type="range" id="spacing" min="0" max="1.5" step="0.0625">
        <label for="rounding">Rounding</label>
        <input type="range" id="rounding" min="0" max="3" step="0.0625">
        <label for="padding">Padding</label>
        <input type="range" id="padding" min="0" max="1.5" step="0.0625">
        <label for="line-height">Line Height</label>
        <input type="range" id="line-height" min="1" max="2.5" step="0.0625">
        <label for="font-size">Font Size</label>
        <input type="range" id="font-size" min="0.5" max="2" step="0.0625">
        <label for="font-weight">Font Weight</label>
        <input type="range" id="font-weight" min="100" max="1000" step="50">
        <label for="border-width">Border Width</label>
        <input type="range" id="border-width" min="0" max="0.25" step="0.03125">
        <label for="override">Override</label>
        <textarea id="override" rows="5" cols="40" readonly></textarea>
      </div>
      <hr>
      <button id="reset-button">Reset</button>
    </div>
  HTML

  MASK_STYLE = <<~HTML
    <style>
      .pagy, .pagy-bootstrap, .pagy-bulma {
        background-color: black !important;
        padding: .5em;
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
    </style>
  HTML

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
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&display=swap" rel="stylesheet">
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
          input[type="number"],
          input[type="range"] {
            all: revert;
          }
          body {
            margin: 0 !important;
            font-family: "Nunito Sans", "Helvetica Neue", Helvetica, Arial, sans-serif !important;
            color: #303030 !important;
          }
          svg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -10;
          }
          h1, h2 {
            font-size: 1.8rem !important;
            font-weight: 600 !important;
            margin-top: 1rem !important;
            margin-bottom: 0.7rem !important;
            line-height: 1.5 !important;
            color: #303030  !important;
          }
          h2 {
            font-family: monospace;
            font-size: .9rem !important;
            margin-top: 1.6rem !important;
          }
          hr {
            height: 0;
            color: inherit;
            border-top-width: 1px;
            border-top-color: gray;
            margin: 8px 0 !important;
          }
          summary, .notes {
            font-size: .8rem;
            margin-top: .6rem;
            font-style: italic;
            cursor: pointer;
          }
          .notes {
            font-family: sans-serif;
            font-weight: normal;
          }
          .notes code{
            background-color: rgba(255, 255, 255, .6);
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
            display: inline-block;
            margin-top: .3rem;
            margin-bottom: 1rem;
            font-size: .8rem !important;
            line-height: 1rem !important;
            color: white;
            background-color: rgb(30 30 30);
            padding: 1rem;
            overflow-x: auto;
            max-width: 100%;
            white-space: pre;
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
            background-color: rgba(0,0,0,.65);
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
            background-color: white;
            padding: 1.5em;
            margin: .3em 0;
            width: fit-content;
            box-shadow: 8px 8px 18px 0px rgba(0,0,0,0.25);
          }
          span.pagy {
            display: block;
          }
          .pagy-bootstrap .pagination {
            margin: 0;
          }
        </style>
        <%=TWEAKER_STYLE if name&.match(/pagy|tailwind/) %>
        <%# MASK_STYLE %>
      </head>
      <body>
        <svg xmlns="http://www.w3.org/2000/svg" width="0" height="0">
          <filter id="noiseFilter">
            <feTurbulence type="fractalNoise" baseFrequency="0.6" numOctaves="100" stitchTiles="stitch" />
            <feColorMatrix type="matrix" values="0.5 0 0 0 0, 0.5 0 0 0 0, 0.5 0 0 0 0, 0 0 0 0.5 0" />
         </filter>
          <rect width="100%" height="100%" filter="url(#noiseFilter)" fill="rgb(255, 255, 255)" />
        </svg>
        <!-- each different class used by each style -->
        <%= style_menu %>
        <div class="main-content">
          <%= yield %>
        </div>
      </body>
      </html>
    ERB
  end

  template :pagy_head do
    <<~ERB
      <link rel="stylesheet" href="/stylesheet/pagy.css">
      <%=TWEAKER_SCRIPT %>
    ERB
  end

  template :tailwind_head do
    <<~ERB
      <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
      <style type="text/tailwindcss">
        <%= Pagy::ROOT.join('stylesheet/pagy-tailwind.css').read %>
      </style>
       <%=TWEAKER_SCRIPT %>
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

  template :template_head do
    '<link rel="stylesheet" href="/stylesheet/pagy.css">'
  end

  template :page do
    <<~ERB
      <h1><%= title = name.to_s; title[0] = title[0].capitalize; title %></h1>

      <% if css_anchor %>
        <p>Check the <u><i><b><a href="http://ddnexus.github.io/pagy/resources/stylesheet/#<%= css_anchor %>" target="blank"><%= css_anchor.gsub('-', '.') %></a></b></u></i>
        for details.</p>
      <% end %>
      </p>
      <div id="main-container">
        <% if name&.match(/pagy|tailwind/) %>
          <%=TWEAKER_HTML %>
        <% end %>

        <div id="content">
          <hr id="top-hr">
          <h2>@records</h2>
          <p id="records"><%= @records.join(',') %></p>

          <h2>@pagy.series_nav<br/>
            <span class="notes">Series nav <code>{slots: 7}</code></span>
          </h2>
          <%= html = @pagy.series_nav(style, classes:,
                                      id: 'series-nav',
                                      aria_label: 'Pages series_nav') %>
          <%= highlight(html) %>

          <h2>@pagy.series_nav_js<br/>
            <span class="notes">Responsive nav: <code>{steps: {0 => 5, 500 => 7, 600 => 9, 700 => 11}}</code><br/>
            (Resize the window to see)
            </span>
          </h2>
          <%= html = @pagy.series_nav_js(style, classes:,
                                         id: 'series-nav-js-responsive',
                                         aria_label: 'Pages series_nav_js_responsive',
                                         steps: { 0 => 5, 500 => 7, 600 => 9, 700 => 11 }) %>
          <%= highlight(html) %>

          <h2>@pagy.input_nav_js</h2>
          <%= html = @pagy.input_nav_js(style, classes:,
                                        id: 'input-nav-js',
                                        aria_label: 'Pages inpup_nav_js') %>
          <%= highlight(html) %>

          <% if name&.match(/pagy|tailwind/) %>
            <h2>@pagy.limit_tag_js</h2>
            <%= html = @pagy.limit_tag_js(id: 'limit-tag-js') %>
            <%= highlight(html) %>
          <% end %>

          <h2>@pagy.info_tag</h2>
          <%= html = @pagy.info_tag(id: 'pagy-info') %>
          <%= highlight(html) %>
                <br><br>
        </div> 
      </div>
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
