class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :blog_comments do |t|
      t.text :comment
      t.integer :rating
      t.integer :likes
      t.integer :post_id
      t.string :status

      t.timestamps
    end
  end
end
