class AddPhotosCountToPhotogs < ActiveRecord::Migration

  def self.up
    add_column :photogs, :photos_count, :integer, :default => 0

    Photog.reset_column_information
    Photog.all.each do |photog|
      Photog.update_counters photog.id, :photos_count => photog.photos.length
    end
  end

  def self.down
    remove_column :photogs, :photos_count
  end
end
