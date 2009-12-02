class Suggestion < ActiveRecord::Base
  validates_presence_of :what
  before_create :ensure_who
  
protected

  def ensure_who
    self.who ||= "Anonymous"
  end
  
end
