class AddSlugToFeedPosts < ActiveRecord::Migration
  def change
    add_column :feed_posts, :slug, :string
    add_index :feed_posts, :slug
  end
end
