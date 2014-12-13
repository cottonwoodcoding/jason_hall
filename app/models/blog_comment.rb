class BlogComment < ActiveRecord::Base
  belongs_to :post, dependent: :destroy

  def self.by_date
    order('created_at DESC')
  end

end
