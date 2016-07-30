class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.text :title
      # t.array :joinedUsers
      t.integer :interests, array: true, default: []
      t.text :description
      t.text :location
      t.boolean :completed
      t.integer :maxUsers
      t.integer :minUsers
      t.datetime :ends
      t.string :pictureUrl
      t.references :owner, :null => true
      t.boolean :challenge
      t.boolean :discount
      # t.references :invitedUsers
    end
  end
end
