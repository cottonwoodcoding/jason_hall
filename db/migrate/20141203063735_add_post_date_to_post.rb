class AddPostDateToPost < ActiveRecord::Migration
  def change
    add_column :posts, :post_date, :datetime
  end
end
