class AddAssignmentTweetedAt < ActiveRecord::Migration

  def self.up
    add_column :assignments, :tweeted_at, :timestamp
  end

  def self.down
    remove_column :assignments, :tweeted_at
  end

end
