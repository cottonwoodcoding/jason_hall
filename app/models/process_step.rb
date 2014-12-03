class ProcessStep < ActiveRecord::Base
  validates :name, :description, :step_number, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
