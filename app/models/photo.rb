#
# Credit: Patrick Lenz (http://github.com/scoop)
# Credit: Urban Hafner (http://github.com/ujh)
#

require 'open-uri'

class Photo < ActiveRecord::Base
    
  validates_presence_of :url
  
  belongs_to :assignment
  belongs_to :photog

  before_create :compute_thumb_url
    
  def self.from_tweet(tweet)
    urls = tweet.scan(/https?:\/\/\S+/)
    if urls.empty?
      nil
    else
      url = urls.detect do |u|
        begin
          URI.parse(u)
        rescue URI::InvalidURIError
          false
        end
      end
      p = Photo.new(:url => url)
      if p.compute_thumb_url
        p
      else
        nil
      end
    end
  end
  
  def compute_thumb_url
    self.thumb_url ||= case
      when self.url =~ /bestc\.am/: bestcam
      when self.url =~ /(tweetphoto|twitpic)\.com/: twitpic
      when self.url =~ /yfrog\.com/: yfrog
      when self.url =~ /farm\d\.static\.flickr\.com/: flickr_static
      when self.url =~ /flickr\.com/: flickr
      when self.url =~ /imgur\.com/: imgur
      when self.url =~ /snaptweet\.com/: snaptweet
      when self.is_compressed : expand
      else nil
    end
  rescue => e
    self.thumb_url = '/images/no-photo.png'
    raise ThumbRetrievalError.new(e, self.url)
  end
  
  class ThumbRetrievalError < StandardError
    attr_accessor :original_exception, :url
    def initialize(original_exception, url)
      self.original_exception, self.url = original_exception, url
    end

    def to_s
      "%s raised %s" % [ url, original_exception ]
    end
  end

protected

  def is_compressed
    self.url =~ /bit\.ly|j\.mp|tr\.im|pnt\.me|tinyurl\.com|(is|pic)\.gd/
  end

  def expand
    expanded_url = ShortURL.new(self.url).expand
    if expanded_url != self.url
      self.url = expanded_url
      compute_thumb_url
    else
      '/images/no-photo.png'
    end
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
    if self.url =~ %r(/p/(\w+))
      photo_id = Base58.base58_to_int($1)
    else
      photo_id = self.url.scan(%r(/photos/[\w@]+/(\d+))).flatten.last
    end
    return unless photo_id
    
    flickr_url = "http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id=#{photo_id}&api_key=#{ENV['FLICKR_API_KEY']}"
    doc = Nokogiri::XML(open(flickr_url))
    doc.css('size[label=Square]').first['source']
  rescue
    raise flickr_url
  end
  
end
