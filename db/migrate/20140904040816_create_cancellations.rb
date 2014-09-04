class CreateCancellations < ActiveRecord::Migration
  def change
    create_table :cancellations do |t|
      t.references :store, index: true
      t.references :user, index: true
      t.text :reason
      t.integer :plan_id
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
