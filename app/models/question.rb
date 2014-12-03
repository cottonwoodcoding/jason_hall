class Question < ActiveRecord::Base
  validates :question, :answer, :question_number, presence: true
  validates_uniqueness_of :question, case_sensitive: false
end
