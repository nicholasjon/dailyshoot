class Photog < ActiveRecord::Base
  validates_presence_of :screen_name, :name
  
  has_many :photos, :dependent => :nullify
  
  def to_param
    screen_name
  end
  
end