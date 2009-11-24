class Assignment < ActiveRecord::Base
  validates_presence_of :text, :tag, :date
end
