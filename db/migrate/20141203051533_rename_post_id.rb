class RenamePostId < ActiveRecord::Migration
  def change
    rename_column :blog_comments, :post_id, :external_post_id
  end
end
