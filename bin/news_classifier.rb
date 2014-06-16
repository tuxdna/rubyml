#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'

require 'html_parser'
require 'classifier'
require 'rss_parser'
require 'cache'

def read_training_data(cache)
  # training data samples
  categories = {
    economy: 'http://en.wikipedia.org/wiki/Economy',
    sport: 'http://en.wikipedia.org/wiki/Sport',
    health: 'http://en.wikipedia.org/wiki/Health'
  }
   
  training_data = {}

  categories.each { |category,url|

    puts "Content for #{category}"
    content = cache.get(category)
    if content.nil? then
      puts "Fetching  #{category}: #{url}"
      hp = HtmlParser.new(url, '.mw-content-ltr')
      content = hp.content
      cache.put(category, content)
    else
      puts "Found in cache"
    end
    training_data[category] = content
  }

  training_data
end

cache = Cache.new

td = read_training_data(cache)
classifier = Classifier.new(td)

results = {
  :economy => [],
  :sport => [],
  :health => []
}


feeds_url = 'http://feeds.reuters.com/reuters/INtopNews?format=xml'
rss_parser = RssParser.new(feeds_url)
rss_parser.article_urls.each do |article_url|
  puts "Article URL => #{article_url}"
  title_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1 > h1'
  caption_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1 > div#slideshowInlineLarge > div#captionContent.rolloverCaption > div.rolloverBg > div.captionText'
  article_text_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1'
  my_selector = 'html body div#content div#articleContent.section div.sectionContent div.sectionColumns div.column1'
  selector = [
              title_selector,
              caption_selector,
              article_text_selector
              # my_selector
             ].join(", ")
  
  article = HtmlParser.new(article_url, selector)
  if article.content.nil? or article.content.length == 0 then
    # skip this article
  else
    puts "Content => #{article.content}"
    scores = classifier.scores(article.content)
    p scores
    category_name, score = scores.max_by{ |k,v| v }
    # DEBUG info
    # p "category: #{category_name}, score: #{score}, scores: #{scores}, url: #{article_url}"
    results[category_name] << article_url
  end
end

p results

