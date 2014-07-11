class CreateFeedPostComments < ActiveRecord::Migration
  def change
    create_table :feed_post_comments do |t|
      t.references :feed_post, index: true
      t.references :user, index: true
      t.text :comment

      t.timestamps
    end
  end
end
