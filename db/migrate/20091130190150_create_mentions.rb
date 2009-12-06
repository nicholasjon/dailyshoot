class CreateMentions < ActiveRecord::Migration
  def self.up
    create_table :mentions do |t|
      t.integer  :tweet_id, :null => false
      t.string   :text, :null => false
      t.integer  :user_id, :null => false
      t.string   :screen_name, :null => false
      t.string   :profile_image_url, :null => false
      t.boolean  :was_parsed, :default => false
      t.datetime :tweeted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :mentions
  end
end
