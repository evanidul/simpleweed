class DropCoupons < ActiveRecord::Migration
  def change
  	drop_table :coupons
  end
end
