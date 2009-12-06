class Suggestion < ActiveRecord::Base
  validates_presence_of :name, :email, :suggestion
end
