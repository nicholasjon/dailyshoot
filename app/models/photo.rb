#
# Credit: Patrick Lenz (http://github.com/scoop)
# Credit: Urban Hafner (http://github.com/ujh)
#

require 'open-uri'

class Photo
  attr_accessor :url, :thumb_url
  
  class ThumbRetrievalError < StandardError
    attr_accessor :original_exception, :url
    def initialize(original_exception, url)
      self.original_exception, self.url = original_exception, url
    end
    
    def to_s
      "%s raised %s" % [ url, original_exception ]
    end
  end
  
  def self.from_tweet(tweet)
    if tweet =~ /(https?:\/\/\S+)/
      Photo.new($1)
    else
      nil
    end
  end

  def initialize(url)
    self.url = url
    compute_thumb_url
  end
  
  protected
  
  def compute_thumb_url
    self.thumb_url = case
      when self.url =~ /bestc\.am/: bestcam
      when self.url =~ /(tweetphoto|twitpic)\.com/: twitpic
      when self.url =~ /yfrog\.com/: yfrog
      when self.url =~ /farm\d\.static\.flickr\.com/: flickr_static
      when self.url =~ /flickr\.com/: flickr
      when self.url =~ /imgur\.com/: imgur
      when self.url =~ /snaptweet\.com/: snaptweet
      else
        expanded_url = ShortURL.new(self.url).expand
        if expanded_url != self.url
          self.url = expanded_url
          compute_thumb_url
        else
          '/images/no-photo.png'
        end
    end
  rescue => e
    raise ThumbRetrievalError.new(e, self.url)
  end
  
  def bestcam
    doc = Nokogiri::HTML(open(self.url))
    doc.css('#main-content .photo img').first['src'].gsub(/iphone/, 'thumb')    
  end
  
  def twitpic
    self.url.gsub(/(\w+)$/, 'show/thumb/\1')
  end
  
  def yfrog
    self.url + '.th.jpg'
  end
  
  def imgur
    uri = URI.parse(self.url)
    uri.host = 'i.imgur.com'
    uri.path.gsub!(/\.(\w+)/, 's.\1')
    "http://#{uri.host}#{uri.path}"
  end
  
  def snaptweet
    doc = Nokogiri::HTML(open(self.url))
    doc.css('.pics img[src*=flickr]').first['src']
  end

  def flickr_static    
    self.url.gsub(/_\w\.jpg/, '_s.jpg')
  end
  
  def flickr
      photo_id = self.url =~ %r(/p/(\w+)) ?
        Base58.base58_to_int($1) :
        self.url.scan(%r(/photos/[\w@]+/(\d+))).flatten.last
      return unless photo_id
      flickr_url = "http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id=#{photo_id}&api_key=#{ENV['FLICKR_API_KEY']}"
      doc = Nokogiri::XML(open(flickr_url))
      doc.css('size[label=Square]').first['source']
    rescue
      raise flickr_url
  end
  
end