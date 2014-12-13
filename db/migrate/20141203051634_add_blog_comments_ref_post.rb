class AddBlogCommentsRefPost < ActiveRecord::Migration
  def change
    add_reference :blog_comments, :post, index: true
  end
end
