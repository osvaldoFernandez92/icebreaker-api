class AddActivityToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :activity, index: :true
  end
end
