class CreateComment < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user
    end
  end
end
