class Photog < ActiveRecord::Base
  validates_presence_of :screen_name, :name
  
  has_many :photos, :dependent => :nullify
  
  def self.for_twitter_user(user)
    photog = self.find_by_screen_name(user.screen_name)
    unless photog
      photog = self.create!(:screen_name => user.screen_name, 
                                   :name => user.name)
    end
    photog
  end
  
  def to_param
    self.screen_name
  end
  
end