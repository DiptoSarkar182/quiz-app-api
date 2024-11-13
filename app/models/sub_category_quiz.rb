class SubCategoryQuiz < ApplicationRecord

  belongs_to :sub_category

  has_many :user_question_histories, dependent: :destroy
end
