class Assignment < ActiveRecord::Base
  validates_presence_of :text
  validates_uniqueness_of :tag
  validates_length_of :text, 
                      :maximum => (140 - 18), 
                      :message => "Only {{count}} characters, please!"

  named_scope :published, lambda {{:order => "date desc", :conditions => ['date <= ?', Date.today]}}
  named_scope :upcoming,  lambda {{:order => "position", :conditions => ['date > ?', Date.today]}}

  acts_as_list

  # before_save alone won't do what we want with acts_as_list 
  before_create :set_tag_and_date
  before_update :set_tag_and_date
  
  has_many :photos, :dependent => :nullify do
    def with_photog(options={})
      find(:all, 
           :joins => :photog,
           :order => 'tweeted_at desc', 
           :select => "photos.*, photogs.screen_name as photog_screen_name")
    end
  end
    
  def self.published_with_photos
    with_scope(:find => {:include => :photos}) do
      self.published
    end
  end
  
  def self.today
    self.first(:conditions => ['date = ?', Date.today])
  end
  
  def self.first_upcoming_position
    unless self.published.first.nil?
      self.published.first.position + 1
    else
      1
    end
  end

  def random_photo
    self.photos[rand(self.photos.length)]
  end
  
  def published?
    self.date <= Date.today
  end
  
  def as_tweet
    "#{self.tweet_date}: #{self.text.strip} ##{self.tag}"
  end
  
  def tweet_date
    self.date.to_s(:tweet_date)
  end
  
  def rfc822_date
    Time.mktime(self.date.year, self.date.month, self.date.day, 9, 0, 0, 0).to_s(:rfc822)
  end
  
  def to_param
    self.position.to_s
  end
  
  def can_move_higher(first_upcoming_position=self.class.first_upcoming_position)
    self.position > first_upcoming_position
  end
  
  def move(direction)
    case direction
      when 'up'   then self.move_higher if self.can_move_higher
      when 'down' then self.move_lower
    end
  end 
  
  def set_tag_and_date
    if self[:position]
      self.tag = "ds#{self[:position]}"
      if self.date.nil? || !self.new_record?
        self.date = Date.tomorrow + (self[:position] - self.class.first_upcoming_position)
      end
    end 
  end
    
end
