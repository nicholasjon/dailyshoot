class RenameSuggestionEmailToUserName < ActiveRecord::Migration
  
  def self.up
    rename_column :suggestions, :email, :twitter_user_name
  end

  def self.down
    rename_column :suggestions, :twitter_user_name, :email
  end
end
