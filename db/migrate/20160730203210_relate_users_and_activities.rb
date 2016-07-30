class RelateUsersAndActivities < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user
      t.references :activity
    end
    create_table :invited_users do |t|
      t.references :user
      t.references :activity
    end
  end
end
