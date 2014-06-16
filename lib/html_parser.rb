require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'


class HtmlParser
  attr_accessor :url, :selector

  def initialize(url, selector)
    @url      = url
    @selector = selector
  end

  def content
    doc = Nokogiri::HTML(open(url))
    html_elements = doc.search(selector)
    html_elements.map { |element| clean_whitespace(element.text) }.join(' ')
  end

  private

  def clean_whitespace(text)
    text.gsub(/\s{2,}|\t|\n/, ' ').strip
  end
end
