class Assignment < ActiveRecord::Base
  validates_presence_of :text, :tag, :date
  validates_length_of :text, :maximum => (140 - 18), :message => "less than {{count}}, please!"

  has_many :photos, :dependent => :nullify do
    def with_photog(options={})
      find(:all, 
           :joins => :photog, 
           :select => "photos.*, photogs.screen_name as photog_screen_name")
    end
  end
  
  def tweet_date
    self.date.to_s(:tweet_date)
  end
  
  def as_tweet
    "#{self.tweet_date}: #{self.text} ##{self.tag}"
  end
  
end
