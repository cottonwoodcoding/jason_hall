class Post < ActiveRecord::Base
  attr_accessible :title, :body, :post_date
  has_many :blog_comments
end
