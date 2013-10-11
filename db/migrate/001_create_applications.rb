class CreateApplications < ActiveRecord::Migration

  def self.up
    add_column :users, :apps, :string, :default => '', :null => false
  end

  def self.down
    remove_column :users, :apps
  end

end
