class Photog < ActiveRecord::Base
  validates_presence_of :screen_name
  
  has_many :photos, :dependent => :nullify
  
  def self.for_twitter_user(user)
    photog = self.find_by_screen_name(user.screen_name)
    unless photog
      photog = self.create!(:screen_name => user.screen_name, 
                            :profile_image_url => user.profile_image_url)
    end
    photog
  end

  def twitter_url
    "http://twitter.com/#{screen_name}"
  end
    
  def to_param
    self.screen_name
  end
  
end