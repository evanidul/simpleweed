class CreateFeedPosts < ActiveRecord::Migration
  def change
    create_table :feed_posts do |t|
      t.references :feed, index: true
      t.references :user, index: true
      t.string :title
      t.text :post
      t.text :link

      t.timestamps
    end
  end
end
