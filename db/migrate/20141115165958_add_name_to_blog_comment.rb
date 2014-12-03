class AddNameToBlogComment < ActiveRecord::Migration
  def change
    add_column :blog_comments, :name, :string
  end
end
