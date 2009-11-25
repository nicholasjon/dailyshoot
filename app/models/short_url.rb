#
# Credit: Patrick Lenz (http://github.com/scoop)
#

require 'open-uri'

class ShortURL
  attr_accessor :url
  
  def initialize(url)
    self.url = url
  end
  
  def expand
    case
      when url =~ /bit\.ly|j\.mp/: bitly
      when url =~ /tr\.im/: trim
      when url =~ /pnt\.me|tinyurl\.com|(is|pic)\.gd/: extract_location_header
      else url
    end
  end
  
protected

  def bitly
    response = open("http://api.bit.ly/expand?version=2.0.1&shortUrl=#{CGI.escape url}&login=#{ENV['BITLY_LOGIN']}&apiKey=#{ENV['BITLY_API_KEY']}").read
    JSON.parse(response)['results'].values.first['longUrl']
  end
  
  def trim
    short = URI.parse(url).path
    response = open("http://api.tr.im/v1/expand?shortUrl=#{short[1..-1]}").read
    JSON.parse(response)['results'].values.first['longUrl']
  end
  
  def extract_location_header
    uri = URI.parse(url)
    
    Net::HTTP.start(uri.host) do |http|
      response = http.head(uri.path)      
      response['location']
    end
  end
end