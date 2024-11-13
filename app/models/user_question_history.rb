class UserQuestionHistory < ApplicationRecord

  belongs_to :user
  belongs_to :sub_category_quiz
end
