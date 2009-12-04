class Suggestion < ActiveRecord::Base
  validates_presence_of :who, :what, :email
end
