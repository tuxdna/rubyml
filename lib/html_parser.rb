require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'
# require 'httpclient'


require 'logger'
require 'net/http'

class RedirectFollower
  class TooManyRedirects < StandardError; end
  
  attr_accessor :url, :body, :redirect_limit, :response
  
  def initialize(url, limit=5)
    @url, @redirect_limit = url, limit
    logger.level = Logger::INFO
  end
  
  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def resolve
    raise TooManyRedirects if redirect_limit < 0
    
    self.response = Net::HTTP.get_response(URI.parse(url))

    logger.info "REDIRECT LIMIT: #{redirect_limit}; RESPONSE CODE: #{response.code}"

    if response.kind_of?(Net::HTTPRedirection)
      self.url = redirect_url
      self.redirect_limit -= 1

      logger.info "redirect found, headed to #{url}"
      resolve
    end
    
    self.body = response.body
    self
  end

  def redirect_url
    if response['location'].nil?
      response.body.match(/<a href=\"([^>]+)\">/i)[1]
    else
      response['location']
    end
  end
end



class HtmlParser
  attr_accessor :url, :selector

  REDIRECT_LIMIT = 5

  def initialize(url, selector)
    @url      = url
    @selector = selector
  end

  def content
    rf = RedirectFollower.new(url, REDIRECT_LIMIT).resolve
    puts "After Redirect => #{rf.redirect_limit} #{rf.body.length} #{rf.url}"
    doc = Nokogiri::HTML(rf.body)
    html_elements = doc.css(selector)
    c = html_elements.map { |element| clean_whitespace(element.text) }.join(' ')
    # puts c
    c
  end

  private

  def clean_whitespace(text)
    text.gsub(/\s{2,}|\t|\n/, ' ').strip
  end
end
