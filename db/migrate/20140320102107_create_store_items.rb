class CreateStoreItems < ActiveRecord::Migration
  def change
    create_table :store_items do |t|
      t.references :store, index: true
      t.string :name
      t.string :description
      t.integer :thc
      t.integer :cbd
      t.integer :cbn
      t.integer :costhalfgram
      t.integer :costonegram
      t.integer :costeighthoz
      t.integer :costquarteroz
      t.integer :costhalfoz
      t.integer :costoneoz
      t.boolean :dogo

      t.timestamps
    end
  end
end
