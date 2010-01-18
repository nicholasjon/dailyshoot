#
# Credit: Patrick Lenz (http://github.com/scoop)
# Credit: Urban Hafner (http://github.com/ujh)
#

require 'open-uri'

class Photo < ActiveRecord::Base
    
  validates_presence_of :url, :thumb_url
  
  belongs_to :assignment, :counter_cache => true
  belongs_to :photog, :counter_cache => true
      
  def self.most_recent(limit=30)
    find(:all, 
         :limit => limit,
         :order => 'tweeted_at desc',
         :joins => :photog, 
         :select => "photos.*, photogs.screen_name as photog_screen_name")
  end
  
  def self.all_from_tweet(tweet)
    photos = []
    urls = tweet.scan(/https?:\/\/\S+/).select do |url|
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        false
      end
    end
    urls.each do |url|
      photo = Photo.new(:url => url)
      if photo.update_image_urls
        photos << photo
      end
    end
    photos
  end
  
  def service_name
    case
      when self.url =~ /bestc\.am/: "The Best Camera"
      when self.url =~ /twitpic/: "TwitPic"
      when self.url =~ /tweetphoto/: "TweetPhoto"
      when self.url =~ /yfrog/: "yFrog"
      when self.url =~ /flic/: "Flickr"
      when self.url =~ /imgur\.com/: imgur
      when self.url =~ /snaptweet/: "SnapTweet"
      when self.url =~ /smugmug/: "SmugMug"
      else "site"
    end
  end
  
  def update_image_urls
    expand_url if is_compressed 
    
    image_urls = case
      when self.url =~ /bestc\.am/: bestcam
      when self.url =~ /twitpic\.com/: twitpic
      when self.url =~ /tweetphoto\.com/: tweetphoto
      when self.url =~ /yfrog\.com/: yfrog
      when self.url =~ /farm\d\.static\.flickr\.com/: flickr_static
      when self.url =~ /flickr\.com/: flickr
      when self.url =~ /flic\.kr/: flickr
      when self.url =~ /imgur\.com/: imgur
      when self.url =~ /snaptweet\.com/: snaptweet
      when self.url =~ /smugmug\.com/: smugmug
      else [nil, nil]
    end
    self.thumb_url = image_urls[0]
    self.medium_url = image_urls[1]
    self.thumb_url
  rescue => e
    self.thumb_url = '/images/no-photo.png'
    self.medium_url = nil
    raise ThumbRetrievalError.new(e, self.url)
  end
  
  def cache_key
    self.url
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
    self.url =~ /bit\.ly|j\.mp|tr\.im|pnt\.me|short\.to|ping\.fm|ow\.ly|tinyurl\.com|tiny\.cc|twurl\.nl|(is|pic)\.gd/
  end

  def expand_url
    self.url = ShortURL.new(self.url).expand
  end
    
  def bestcam
    doc = Nokogiri::HTML(open(self.url))
    medium = doc.css('#main-content .photo img').first['src']    
    thumb = medium.gsub(/iphone/, 'thumb')   
    [thumb, medium]
  end
  
  def twitpic
    thumb = self.url.gsub(/(\w+)$/, 'show/thumb/\1')
    [thumb, thumb]
  end

  def tweetphoto
    api_url = "http://TweetPhotoAPI.com/api/TPAPI.svc/imagefromurl?size=thumbnail&url="
    thumb = open(api_url + self.url) { |f| f.base_uri.to_s }
    api_url = "http://TweetPhotoAPI.com/api/TPAPI.svc/imagefromurl?size=medium&url="
    medium = open(api_url + self.url) { |f| f.base_uri.to_s }
    [thumb, medium]
  end
  
  # http://yfrog.com/4izptj
  def yfrog
    #thumb = self.url + '.th.jpg'
    if self.url =~ %r(/([\w\d]+)$)
      photo_id = $1
    else
      return [nil, nil]
    end
    
    api_url = "http://yfrog.com/api/xmlInfo?path="
    doc = Nokogiri::XML(open(api_url + photo_id))
    thumb = doc.css('thumb_link').first.text
    medium = doc.css('image_link').first.text
    [thumb, medium]
  end
  
  def imgur
    uri = URI.parse(self.url)
    uri.host = 'i.imgur.com'
    uri.path.gsub!(/\.(\w+)/, 's.\1')
    thumb = "http://#{uri.host}#{uri.path}"
    [thumb, thumb]
  end
  
  def snaptweet
    doc = Nokogiri::HTML(open(self.url))
    flickr_static_url = doc.css('.pics img[src*=flickr]').first['src']
    
    photo_id = flickr_static_url.scan(%r(/(\d+)_[\w\d@-]+)).flatten.last
    return [nil, nil] unless photo_id
      
    flickr_with_photo_id(photo_id)
  end

  # http://farm{farm-id}.static.flickr.com/{server-id}/{photo-id}_{secret}.jpg.
  def flickr_static  
    photo_id = self.url.scan(%r(/(\d+)_[\w\d@-]+)).flatten.last
    return [nil, nil] unless photo_id
      
    flickr_with_photo_id(photo_id)
  end

  # There's a flickr gem to do this, too.  
  def flickr
    if self.url =~ %r(/p/(\w+))
      photo_id = Base58.base58_to_int($1)
    else
      photo_id = self.url.scan(%r(/photos/[\w@-]+/(\d+))).flatten.last
    end
    return [nil, nil] unless photo_id
    
    flickr_with_photo_id(photo_id)
  end
  
  def flickr_with_photo_id(photo_id)
    flickr_url = "http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id=#{photo_id}&api_key=#{ENV['FLICKR_API_KEY']}"
    doc = Nokogiri::XML(open(flickr_url))
    if doc.xpath('/rsp/@stat').first.value == "ok"
      thumb = doc.xpath("//size[@label='Square']").first['source']
      medium = doc.xpath("//size[@label='Medium']").first
      if medium 
        medium = medium['source']
      else
        medium = thumb
      end
    else
      raise "Flickr API failed"
    end
    [thumb, medium]
  end
  
  # 
  # Form:
  #   /AlbumID_AlbumKey#ImageID_ImageKey
  # 
  # Example: 
  #   http://bluecamel.smugmug.com/Photography/dailyshoot/10469863_EdveS#748954599_NUvea
  # 
  # Image ID = 748954599 (all numeric)
  # Image Key = NUvea (mixed case, case sensitive)
  def smugmug
    if self.url =~ %r(#([0-9]+)_([a-zA-Z0-9]+))
      image_id, image_key = $1, $2
    else
      return
    end
    
    session_url = "http://api.smugmug.com/services/api/rest/1.2.2/?method=smugmug.login.anonymously&APIKey=#{ENV['SMUGMUG_API_KEY']}"
    doc = Nokogiri::XML(open(session_url))
    if doc.xpath('/rsp/@stat').first.value == "ok"
      session_id = doc.xpath('//Session/@id').first.value
    else
      raise "SmugMug session failed"
    end
    
    images_url = "http://api.smugmug.com/services/api/rest/1.2.2/?method=smugmug.images.getURLs&SessionID=#{session_id}&ImageID=#{image_id}&ImageKey=#{image_key}"
    doc = Nokogiri::XML(open(images_url))
    if doc.xpath('/rsp/@stat').first.value == "ok"
      thumb = doc.xpath('//Image/@TinyURL').first.value
      medium = doc.xpath('//Image/@MediumURL').first.value
    else
      raise "SmugMug API failed"
    end
    [thumb, medium]
  end
  
end
