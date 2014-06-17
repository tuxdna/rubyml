#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'
require 'digest/sha1'

require 'html_parser'
require 'classifier'
require 'rss_parser'
require 'cache'

def read_training_data(categories, cache)
  # training data samples
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

def fetch_article(article_url)
  puts "Article URL => #{article_url}"
  title_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1 > h1'
  caption_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1 > div#slideshowInlineLarge > div#captionContent.rolloverCaption > div.rolloverBg > div.captionText'
  article_text_selector = 'html > body > div#content > div#articleContent.section > div.sectionContent > div.sectionColumns > div.column1'
  selector = [
              title_selector,
              caption_selector,
              article_text_selector
             ].join(", ")
  
  article = HtmlParser.new(article_url, selector)
end

cache = Cache.new
categories = {
  economy: 'http://en.wikipedia.org/wiki/Economy',
  sport: 'http://en.wikipedia.org/wiki/Sport',
  health: 'http://en.wikipedia.org/wiki/Health',
  science: 'http://en.wikipedia.org/wiki/Science'
}
td = read_training_data(categories, cache)
classifier = Classifier.new(td)


# results = {:economy => [], :sport => [], :health => []}
results = Hash[categories.map { |k,v| [k, []] }]
feeds_url = 'http://feeds.reuters.com/reuters/INtopNews?format=xml'
rss_parser = RssParser.new(feeds_url)

rss_parser.article_urls.each do |article_url|

  # first read from cache
  article_key = Digest::SHA1.hexdigest article_url
  cached_content = cache.get(article_key)
  if cached_content.nil? then
    article = fetch_article(article_url)
    article_content = article.content
    cache.put(article_key, article_content)
  else
    article_content = cached_content
  end

  if article_content.nil? or article_content.length == 0 then
    # skip this article
    puts "Skipping... no data in this article"
  else
    puts "Content length => #{article_content.length}"
    scores = classifier.scores(article_content)
    p scores
    category_name, score = scores.max_by{ |k,v| v }
    # DEBUG info
    # p "category: #{category_name}, score: #{score}, scores: #{scores}, url: #{article_url}"
    results[category_name] << article_url
  end
end

p results

