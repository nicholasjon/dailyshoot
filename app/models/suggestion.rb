class Suggestion < ActiveRecord::Base
  validates_presence_of :what
end
