# coding: utf-8
require 'mechanize'

# usage: ruby get_flier.rb <channel> <token>
url = "http://www.super-fresco.co.jp/flier/"
agent = Mechanize.new

channel = ARGV[0]
token = ARGV[1]

agent.get(url) do |page|
  filer_url = page.search(".//div[@id='dl-area']/table/tr")[1].search(".//td")[0].search(".//a")[0].attr("href")
  file_name = filer_url.split("/").last
  if File.exist?(file_name)
    puts "File #{file_name} already exists."
  else
    puts "Downloading #{filer_url}"
    agent.get(filer_url).save_as(file_name)
    `slackcat -c #{channel} -k #{token} -m #{file_name}`
  end
end
