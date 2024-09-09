#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'net/http'
require_relative 'scripty'
include Scripty  # rubocop:disable Style/MixinUsage

USERS_URL_FMT   = 'https://api.github.com/repos/ddnexus/pagy/contributors?page=%s'
COMMITS_URL_FMT = 'https://github.com/ddnexus/pagy/commits?author=%s'
IMG_WIDTH = '40'
MAX_COUNT = 100

top100 = +"\n"
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
top100 << "\n"

replace_section_in_file('README.md', 'top100', top100)

puts %("Top 100 Contributors" README section updated! (#{count}/#{MAX_COUNT}))
