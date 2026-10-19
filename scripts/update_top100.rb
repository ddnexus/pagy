#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'scripty'
include Scripty  # rubocop:disable Style/MixinUsage

# Returns at most 100 contributors (the top ones by commits, bots included) with their weekly additions/deletions,
# so after excluding dependabot the README section can hold fewer than MAX_COUNT entries
STATS_URL       = 'https://api.github.com/repos/ddnexus/pagy/stats/contributors'
COMMITS_URL_FMT = 'https://github.com/ddnexus/pagy/commits?author=%s'
IMG_WIDTH = '40'
MAX_COUNT = 100
RETRIES   = 10

# GitHub answers 202 while it computes the stats, 200 once they are ready
stats = nil
RETRIES.times do
  response = Net::HTTP.get_response(URI(STATS_URL))
  case response.code
  when '200' then break stats = JSON.parse(response.body)
  when '202' then sleep 3
  else abort("GitHub returned #{response.code}: #{response.body}")
  end
end
abort('GitHub stats not ready: retry later') unless stats

contributors = stats.filter_map do |c|
  author = c['author']
  next if author.nil? || author['login'] == 'dependabot[bot]'

  lines = c['weeks'].sum { |w| w['a'] + w['d'] }
  [author, lines, c['total']]
end
contributors.sort_by! { |_, lines, commits| [-lines, -commits] }

top100 = +"\n"
contributors.first(MAX_COUNT).each do |author, lines, commits|
  top100 << %([<img src="#{author['avatar_url']}" width="#{IMG_WIDTH}" title="@#{author['login']}: #{
    lines} #{lines == 1 ? 'line' : 'lines'} in #{commits} #{commits == 1 ? 'commit' : 'commits'}">](#{
    format(COMMITS_URL_FMT, author['login'])}))
end
top100 << "\n"

replace_section_in_file('README.md', 'top100', top100)

count = [contributors.size, MAX_COUNT].min
puts %("Top 100 Contributors" README section updated! (listed #{count} contributors))
