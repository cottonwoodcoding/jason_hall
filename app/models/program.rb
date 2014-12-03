class Program < ActiveRecord::Base
  validates :loan_type, :description, presence: true
  validates_uniqueness_of :loan_type, case_sensitive: false
end
