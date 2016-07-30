class AddDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :integer
    add_column :users, :age, :integer
    add_column :users, :description, :text
    add_column :users, :interests, :integer, array: true, default: []
  end
end
