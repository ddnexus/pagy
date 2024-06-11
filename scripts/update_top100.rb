#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'

USERS_URL_FMT   = 'https://api.github.com/repos/ddnexus/pagy/contributors?page=%s'
COMMITS_URL_FMT = 'https://github.com/ddnexus/pagy/commits?author=%s'
IMG_WIDTH = '40'
MAX_COUNT = 100
START_TAG = '<!-- top100 start -->'
END_TAG   = '<!-- top100 end -->'

top100 = "#{START_TAG}\n"
count  = 0
page   = 1
until count >= MAX_COUNT || (users = JSON.parse(Net::HTTP.get(URI(format(USERS_URL_FMT, page))))).empty?
  users&.each do |u|
    break if count >= MAX_COUNT
    next if u['login'] == 'dependabot[bot]'

    contribution = u['contributions'] == 1 ? 'contribution' : 'contributions'
    top100 << %([<img src="#{u['avatar_url']}" width="#{IMG_WIDTH}" title="@#{
    u['login']}: #{u['contributions']} #{contribution}">](#{format(COMMITS_URL_FMT, u['login'])}))
    count += 1
  end
  page += 1
end
top100 << "\n#{END_TAG}"

readme_path = File.expand_path('../README.md', __dir__)
content     = File.read(readme_path)
content.sub!(/#{START_TAG}.*#{END_TAG}/mo, top100)
File.write(readme_path, content)

puts %("Top 100 Contributors" README section updated! (#{count}/#{MAX_COUNT}))
