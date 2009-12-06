class RenameSuggestionColumns < ActiveRecord::Migration

  def self.up
    rename_column :suggestions, :who,  :name
    rename_column :suggestions, :what, :suggestion
  end

  def self.down
  end
  
end
