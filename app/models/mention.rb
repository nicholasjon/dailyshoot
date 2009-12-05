class Mention < ActiveRecord::Base
  validates_presence_of :tweet_id, :text, :user_id, :screen_name, :profile_image_url
  
  named_scope :pending, :conditions => ['was_parsed = ?', false]

  attr_reader :parse_message
    
  def self.from_raw_mention(raw_mention)
    Mention.new(:tweet_id => raw_mention[:id].to_i,
                :text => raw_mention.text,
                :user_id => raw_mention.user[:id].to_i, 
                :screen_name => raw_mention.user.screen_name,
                :profile_image_url => raw_mention.user.profile_image_url,
                :tweeted_at => raw_mention.created_at)
  end
  
  def tag
    self.text =~ /#(ds\d{1,3})/ ? $1 : nil
  end

  def assignment
    self.tag ? Assignment.find_by_tag(self.tag) : nil
  end
  
  def photos
    Photo.all_from_tweet(self.text)
  end
  
  def photog
    Photog.with_screen_name(self.screen_name)
  end
  
  def parse!
    @parse_message = ""
    unless self.tag
      @parse_message = "No hashtag: #{self.text}"
      return false
    end

    assignment = self.assignment
    unless assignment
      @parse_message = "Unknown assignment tag: #{self.tag}"
      return false
    end

    photos = self.photos
    if photos.empty?
      @parse_message = "Photo URL parse error: #{self.text}" 
      return false
    end

    photog = self.photog

    photos = photos.select do |photo| 
      Photo.find_by_url_and_photog_id(photo.url, photog.id).nil?
    end
    if photos.empty?
      @parse_message = "Duplicate - skipping: #{self.text}"
      return false
    end

    if photog.new_record?
      photog.profile_image_url = self.profile_image_url
      photog.save!
    end

    photos.each do |photo|    
      photo.tweet_id = self.tweet_id
      photo.tweeted_at = self.tweeted_at
      photo.assignment = assignment
      photo.photog = photog
      photo.screen_name = photog.screen_name
      photo.save!
    end

    self.was_parsed = true
    self.save

  rescue => e
    @parse_message = "Unable to collect mention: #{self.text}: #{e.inspect}"
    return false
  end
  
end