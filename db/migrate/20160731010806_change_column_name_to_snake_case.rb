class ChangeColumnNameToSnakeCase < ActiveRecord::Migration
  def change
    rename_column :activities, :pictureUrl, :picture_url
  end
end
