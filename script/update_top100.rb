#!/usr/bin/env ruby
# frozen_string_literal: true

require 'http'
require 'net/http'

url_fmt     = 'https://api.github.com/repos/ddnexus/pagy/contributors?page=%s'
width       = '64'
page        = 1
top100start = '<!-- top100 start -->'
top100end   = '<!-- top100 end -->'

top100 = "#{top100start}\n"
until (contributors = JSON.parse(Net::HTTP.get(URI(format(url_fmt, page))))).empty?
  contributors.each do |c|
    commits = c['contributions'] == 1 ? 'commit' : 'commits'
    top100 << %([<img src="#{c['avatar_url']}" width="#{width}" title="@#{
    c['login']}: #{c['contributions']} #{commits}">](https://github.com/#{c['login']}))
  end
  page += 1
end
top100 << "\n#{top100end}"

readme_path = File.expand_path('../README.md', __dir__)
content     = File.read(readme_path)
content.sub!(/#{top100start}.*#{top100end}/m, top100)
File.write(readme_path, content)

puts 'Top 100 Contributors README section updated!'
