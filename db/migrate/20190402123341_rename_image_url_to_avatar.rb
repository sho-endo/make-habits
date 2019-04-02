class RenameImageUrlToAvatar < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :image_url, :avatar
  end
end
