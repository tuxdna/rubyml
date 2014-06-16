#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'

require 'html_parser'
require 'classifier'
require 'rss_parser'
require 'fileutils'

CACHE_FOLDER="./cache"

def get_from_cache(category) 
  filename = "#{CACHE_FOLDER}/#{category}.seralized.cache"
  if File.exists?(filename) then
    f = File.new(filename, "r")
    x = f.read
    Marshal.load(x)
  else
    nil
  end
end

def add_to_cache(category, data)
  if ! File.exists?(CACHE_FOLDER) then
    FileUtils.mkdir_p(CACHE_FOLDER)
  end

  filename = "#{CACHE_FOLDER}/#{category}.seralized.cache"
  f = File.new(filename, "w")
  x = Marshal.dump(data)
  f.write(x)
  f.close
end

def read_training_data() 
  # training data samples
  categories = {
    economy: 'http://en.wikipedia.org/wiki/Economy',
    sport: 'http://en.wikipedia.org/wiki/Sport',
    health: 'http://en.wikipedia.org/wiki/Health'
  }
   
  training_data = {}

  categories.each { |category,url|

    puts "Content for #{category}"
    content = get_from_cache(category)
    if content.nil? then
      puts "Fetching  #{category}: #{url}"
      hp = HtmlParser.new(url, '.mw-content-ltr')
      content = hp.content
      add_to_cache(category, content)
    else
      puts "Found in cache"
    end
    training_data[category] = content
  }

  training_data
end

td = read_training_data
classifier = Classifier.new(td)

results = {
  :economy => [],
  :sport => [],
  :health => []
}

rss_parser = RssParser.new('http://feeds.reuters.com/reuters/INtopNews?format=xml')
rss_parser.article_urls.each do |article_url|
  puts article_url
  article = HtmlParser.new(article_url, '#article .area > h3, #article .area > p, #article > h3')
  scores = classifier.scores(article.content)
  p scores
  category_name, score = scores.max_by{ |k,v| v }
  # DEBUG info
  # p "category: #{category_name}, score: #{score}, scores: #{scores}, url: #{article_url}"
  results[category_name] << article_url
end

p results

