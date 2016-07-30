class ChangeAttributesFromActivity < ActiveRecord::Migration
  def change
    rename_column :activities, :maxUsers, :max_users
    rename_column :activities, :minUsers, :min_users
  end
end
