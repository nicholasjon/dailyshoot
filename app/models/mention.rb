class Mention < ActiveRecord::Base
  validates_presence_of :tweet_id, :text, :user_id, :screen_name, :profile_image_url
  
  named_scope :pending, :conditions => ['was_parsed = ?', false]
  
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
  
end