class AddIndexableToCampaigns < ActiveRecord::Migration
  def up
    add_column :campaigns, :indexable, :boolean, :default => true
  end

  def down
    remove_column :campagins, :indexable
  end
end
