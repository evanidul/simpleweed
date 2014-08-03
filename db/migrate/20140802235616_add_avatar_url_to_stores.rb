class AddAvatarUrlToStores < ActiveRecord::Migration
  def change
    add_column :stores, :avatar_url, :string
  end
end
