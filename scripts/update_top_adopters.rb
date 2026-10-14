#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the "Top Adopters" README section: a wall of SVG tiles (logo, background in a secondary color of the logo,
# star count) linking to the most starred repos that depend on pagy, plus the total count of dependents.
#
# GitHub has no API for the dependents graph, so the dependents are scraped from the HTML pages (newest first) into
# the dependents.tsv index ("<user>/<repo>\t<stars>" sorted by stars). The details of the top repos (fresh stars,
# description, avatar) come from the API: set GITHUB_TOKEN to lift its unauthenticated rate limit. The background
# colors are picked with ImageMagick (magick). A logo with a hard background can be replaced by a transparent PNG
# in logo_overrides/<user>-<repo>.png (e.g. flood-filling the corners: magick in.png -fuzz 8% -fill none
# -draw 'alpha 0,0 floodfill' ... out.png).
#
#   scripts/update_top_adopters.rb          # incremental: stop at the first page without new repos (stale stars are fine)
#   scripts/update_top_adopters.rb --full   # rescan all the dependents, refreshing the stars and dropping the stale repos

require 'base64'
require 'cgi'
require 'json'
require 'net/http'
require 'open3'
require_relative 'scripty'
include Scripty  # rubocop:disable Style/MixinUsage

INDEX_FILE     = File.expand_path('dependents.tsv', __dir__)
OVERRIDES_DIR  = File.expand_path('logo_overrides', __dir__)
TILES_DIR      = 'assets/images/top-adopters' # relative to the repo root, as the README references it
DEPENDENTS_URL = 'https://github.com/ddnexus/pagy/network/dependents'
REPO_API_FMT   = 'https://api.github.com/repos/%s'
GENERIC_LOGO   = 'https://github.githubassets.com/images/icons/emoji/unicode/1f4e6.png' # 📦 for user-owned repos
# One dependent row: the repo link, then the star count in the first stats span
ROW_RE   = %r{data-hovercard-type="repository"[^>]*href="/([^/"]+/[^/"]+)".*?octicon-star.*?</svg>\s*([\d,]+)}m
NEXT_RE  = /href="([^"]+)">Next</
COUNT_RE = /([\d,]+)\s+Repositories/
RETRY_WAIT = 60 # seconds, when GitHub rate-limits the scraping
TOP        = 25
EXCLUDED   = %w[NixOS/nixpkgs].freeze # packagers, not users
TILE       = 64
PILL_COLOR = '#1f2328'
FONT       = %(-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Noto Sans', Helvetica, Arial, sans-serif)

abort('ImageMagick (magick) is required') unless system('magick -version', out: File::NULL, err: File::NULL)

# Update the dependents index
full       = ARGV.include?('--full') || !File.exist?(INDEX_FILE)
dependents = full ? {} : File.readlines(INDEX_FILE, chomp: true).to_h { |line| line.split("\t") }.transform_values(&:to_i)
url        = DEPENDENTS_URL
page       = 0
total      = nil
while url
  response = Net::HTTP.get_response(URI(url))
  if response.code == '429'
    wait = (response['retry-after'] || RETRY_WAIT).to_i
    warn "rate limited: waiting #{wait}s"
    sleep wait
    next
  end
  raise "HTTP #{response.code} for #{url}" unless response.code == '200'

  body = response.body
  total ||= body[COUNT_RE, 1].delete(',').to_i
  rows = body.scan(ROW_RE).to_h { |repo, stars| [repo, stars.delete(',').to_i] }
  new  = rows.keys - dependents.keys
  dependents.merge!(rows)
  page += 1
  warn "page #{page}: #{new.size} new repos (#{dependents.size} total)"
  break if !full && new.empty?

  url = body[NEXT_RE, 1]&.gsub('&amp;', '&')
end
dependents = dependents.sort_by { |repo, stars| [-stars, repo] }.to_h
File.write(INDEX_FILE, dependents.map { |repo, stars| "#{repo}\t#{stars}\n" }.join)
warn "#{INDEX_FILE} updated (#{full ? 'full' : 'incremental'} scan, #{dependents.size} repos)"

# Fetch the details of the top repos
headers = ENV['GITHUB_TOKEN'] ? { 'Authorization' => "Bearer #{ENV['GITHUB_TOKEN']}" } : {}
top     = dependents.keys.reject { |repo| EXCLUDED.include?(repo) }.first(TOP).map do |repo|
  JSON.parse(Net::HTTP.get(URI(format(REPO_API_FMT, repo)), headers))
end
top.sort_by! { |r| -r['stargazers_count'] }

# Tile helpers
def hex(rgb) = format('#%02x%02x%02x', *rgb)

# Blend a color toward white
def tint(rgb, amount) = rgb.map { |c| ((c * (1 - amount)) + (255 * amount)).round }

# Saturated and mid-light: a color that is not a white/black/gray part of the logo
def vivid?(rgb)
  max = rgb.max
  min = rgb.min
  l   = (max + min) / 510.0
  sat = max == min ? 0 : (max - min) / (255.0 - ((2 * l * 255) - 255).abs)
  sat > 0.25 && l.between?(0.15, 0.8)
end

def distance(a, b) = Math.sqrt(a.zip(b).sum { |x, y| (x - y)**2 })

# The 8 quantized opaque colors of a logo, most frequent first
def palette(png)
  args = %w[- -alpha on -colors 8 -depth 8 -format %c histogram:info:]
  out, = Open3.capture2('magick', *args, stdin_data: png)
  out.scan(/(\d+):\s+\((\d+),(\d+),(\d+)(?:,(\d+))?\)/).map { |n, *rgb, a| [n.to_i, rgb.map(&:to_i), (a || 255).to_i] }
     .select { |_, _, a| a > 127 }.sort_by { |n, *| -n }.map { |_, rgb, _| rgb }
end

# Background of a tile: the second most frequent vivid color of the logo, or a pastel tint of the main one
def background(png)
  pal  = palette(png)
  main = pal.find { |rgb| vivid?(rgb) } || pal.first || [124, 179, 66]
  pick = pal.find { |rgb| vivid?(rgb) && distance(rgb, main) > 80 }
  hex(pick || tint(main, 0.78))
end

def thousands(number) = number.to_s.gsub(/(\d)(?=(\d{3})+$)/, '\1,')

def stars(count) = count >= 1000 ? "#{(count / 1000.0).round(1).to_s.sub(/\.0$/, '')}k" : count.to_s

# Square pill flush in the bottom-right corner
def pill(text, font: 10, pad: 2, h: 14)
  w = (text.size * font * 0.58).round + (2 * pad)
  %(<rect x="#{TILE - w}" y="#{TILE - h}" width="#{w}" height="#{h}" fill="#{PILL_COLOR}"/>) +
    %(<text x="#{TILE - (w / 2.0)}" y="#{TILE - 4}" text-anchor="middle" font-size="#{font}" font-weight="600" fill="#fff" ) +
    %(font-family="#{FONT}">#{text}</text>)
end

def tile(repo)
  override = "#{OVERRIDES_DIR}/#{repo['full_name'].tr('/', '-')}.png"
  image    = if File.exist?(override)
               File.binread(override)
             else
               Net::HTTP.get(URI(repo['owner']['type'] == 'User' ? GENERIC_LOGO : "#{repo['owner']['avatar_url']}&s=128"))
             end
  png, = Open3.capture2('magick', '-', '-resize', '128x128', 'png:-', stdin_data: image) # avatars can be JPEG, GIF...
  <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" width="#{TILE}" height="#{TILE}" viewBox="0 0 #{TILE} #{TILE}">
    <rect width="#{TILE}" height="#{TILE}" fill="#{background(png)}"/>
    <image href="data:image/png;base64,#{Base64.strict_encode64(png)}" width="#{TILE}" height="#{TILE}"/>
    #{pill(stars(repo['stargazers_count']))}
    </svg>
  SVG
end

# Write the tiles and the README section
tiles_dir = ROOT.join(TILES_DIR)
tiles_dir.mkpath
tiles_dir.glob('*.svg').each(&:delete)
wall = top.map do |repo|
  file = "#{repo['full_name'].tr('/', '-').downcase}.svg" # lowercase: retype lowercases the asset names it publishes
  tiles_dir.join(file).write(tile(repo))
  name  = repo['name'].tr('_-', '  ').split.map { |word| word.sub(/^./, &:upcase) }.join(' ') # title case
  title = [CGI.escapeHTML("#{name} ⭐ #{thousands(repo['stargazers_count'])}"),
           repo['description'] && CGI.escapeHTML(repo['description'])].compact.join('&#10;') # &#10; = new line in a tooltip
  %([<img src="#{TILES_DIR}/#{file}" title="#{title}">](#{repo['html_url']}))
end
more = (total / 100) * 100 # e.g. 13,568 -> "13,500+"
replace_section_in_file('README.md', 'top_adopters', <<~MD)

  #{wall.join}

  …and [#{thousands(more)}+ more public repos](#{DEPENDENTS_URL}) on GitHub.

MD

puts %("Top Adopters" README section updated! (#{top.size} tiles, #{total} dependents))
