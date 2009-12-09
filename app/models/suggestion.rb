class Suggestion < ActiveRecord::Base
  validates_presence_of :name, :twitter_user_name, :suggestion
end
