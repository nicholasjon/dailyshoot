class Photog < ActiveRecord::Base
  validates_presence_of :screen_name
  
  has_many :photos, :dependent => :nullify do
    def with_assignment(options={})
      find(:all, 
           :joins => [:assignment, :photog],
           :select => "photos.*, photogs.screen_name as photog_screen_name, assignments.position as assignment_position, assignments.tag as assignment_tag",
           :order => "assignments.position desc")
    end
  end
  
  def self.all_by_photos_count
    all(:order => 'photos_count desc')
  end
  
  def self.with_screen_name(screen_name)
    self.find_by_screen_name(screen_name) || self.new(:screen_name => screen_name)
  end

  def twitter_url
    "http://twitter.com/#{screen_name}"
  end
    
  def to_param
    self.screen_name
  end
  
end