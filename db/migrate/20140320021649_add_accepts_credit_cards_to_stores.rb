class AddAcceptsCreditCardsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :acceptscreditcards, :boolean
  end
end
