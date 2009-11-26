class CreatePhotogs < ActiveRecord::Migration
  
  def self.up
    create_table :photogs do |t|
      t.string  :screen_name
      t.string  :name
      t.timestamps
    end
    add_index :photogs, :screen_name, :unique => true
  end

  def self.down
    drop_table :photogs
  end
end