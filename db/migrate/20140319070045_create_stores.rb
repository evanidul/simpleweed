class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :addressline1
      t.string :city
      t.string :state
      t.string :zip
      t.string :phonenumber

      t.timestamps
    end
  end
end
