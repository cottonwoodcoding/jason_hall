class BlogComment < ActiveRecord::Base

  def self.by_date
    order('created_at DESC')
  end

end
