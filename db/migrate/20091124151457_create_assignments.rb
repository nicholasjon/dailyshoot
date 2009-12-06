class CreateAssignments < ActiveRecord::Migration
  
  def self.up
    create_table :assignments do |t|
      t.string  :text, :null => false
      t.date    :date, :null => false
      t.string  :tag, :null => false
      t.integer :position
      t.integer :photos_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
