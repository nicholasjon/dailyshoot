class AddPhotosCountToAssignments < ActiveRecord::Migration

  def self.up
    add_column :assignments, :photos_count, :integer, :default => 0

    Assignment.reset_column_information
    Assignment.all.each do |assignment|
      Assignment.update_counters assignment.id, :photos_count => assignment.photos.length
    end
  end

  def self.down
    remove_column :assignments, :photos_count
  end
end
