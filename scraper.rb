require 'faraday'
require 'faraday/gzip'
require 'nokogiri'

# Hello!

conn = Faraday.new(
  url: 'https://chicagoevents.com',
  headers: { 
    'Content-Type' => 'application/json',
    'User-Agent' => 'MyScraper' # Agent can be whatever
  }
) do |f|
  f.request :gzip # Enable gzip compression for requests
end

# GET
res = conn.get('https://chicagoevents.com/vendors-and-artists/')
doc = Nokogiri::HTML(res.body)


articles = doc.css('.tribe-events-pro-photo__event-details')

articles.each do |article|
  date = article.at_css('.event-date')&.text&.strip
  title = article.at_css('h3')&.text&.strip
  link = article.at_css('a')
  link_text = link&.text&.strip
  link_href = link&.[]('href')

  puts "Event: #{title}"
  puts "Date: #{date}"
  puts "Link: #{link_text}"
  puts "Link href: #{link_href}"
  puts "=============================="
end

