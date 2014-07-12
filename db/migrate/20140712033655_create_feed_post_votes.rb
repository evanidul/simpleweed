class CreateFeedPostVotes < ActiveRecord::Migration
  def change
    create_table :feed_post_votes do |t|
      t.references :feed_post, index: true
      t.references :user, index: true
      t.integer :vote

      t.timestamps
    end
  end
end
