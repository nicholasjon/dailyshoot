class AddMediumUrlToPhotos < ActiveRecord::Migration
  
  def self.up
    add_column :photos, :medium_url, :string
  end

  def self.down
    remove_column :photos, :medium_url
  end
end
