class AddEmailToSuggestions < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :email, :string
  end

  def self.down
    remove_column :suggestions, :email
  end
end
