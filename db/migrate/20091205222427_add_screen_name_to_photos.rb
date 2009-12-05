class AddScreenNameToPhotos < ActiveRecord::Migration

  def self.up
    add_column :photos, :screen_name, :string

    Photo.reset_column_information
    Photo.all.each do |photo|
      photo.screen_name = photo.photog.screen_name
      photo.save!
    end
  end

  def self.down
    remove_column :photos, :screen_name
  end
end
