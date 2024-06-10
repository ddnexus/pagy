#!/usr/bin/env ruby
# frozen_string_literal: true

require 'http'
require 'net/http'

URL_FMT   = 'https://api.github.com/repos/ddnexus/pagy/contributors?page=%s'
IMG_WIDTH = '40'
MAX_COUNT = 100
START_TAG = '<!-- top100 start -->'
END_TAG   = '<!-- top100 end -->'
count     = 0
page      = 1

top100 = "#{START_TAG}\n"
until count >= MAX_COUNT || (contributors = JSON.parse(Net::HTTP.get(URI(format(URL_FMT, page))))).empty?
  contributors.each do |c|
    break if count >= MAX_COUNT
    next if c['login'] == 'dependabot[bot]'

    contribution = c['contributions'] == 1 ? 'contribution' : 'contributions'
    top100 << %([<img src="#{c['avatar_url']}" width="#{IMG_WIDTH}" title="@#{
    c['login']}: #{c['contributions']} #{contribution}">](https://github.com/ddnexus/pagy/commits?author=#{c['login']}))
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
