class Assignment < ActiveRecord::Base
  validates_presence_of :text, :tag, :date
  validates_uniqueness_of :tag
  validates_length_of :text, :maximum => (140 - 18), :message => "less than {{count}}, please!"
  
  named_scope :published, :order => "date desc", :conditions => ['date <= ?', Date.today]
  named_scope :upcoming,  :order => "date desc", :conditions => ['date > ?', Date.today]

  has_many :photos, :dependent => :nullify do
    def with_photog(options={})
      find(:all, 
           :joins => :photog, 
           :select => "photos.*, photogs.screen_name as photog_screen_name")
    end
  end
  
  def self.today
    self.first(:conditions => ['date = ?', Date.today])
  end
  
  def as_tweet
    "#{self.tweet_date}: #{self.text} ##{self.tag}"
  end
  
  def tweet_date
    self.date.to_s(:tweet_date)
  end
  
  def rfc822_date
    Time.mktime(self.date.year, self.date.month, self.date.day, 9, 0, 0, 0).to_s(:rfc822)
  end  
end
