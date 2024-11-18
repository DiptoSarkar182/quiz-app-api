class SubCategoryQuiz < ApplicationRecord
  belongs_to :sub_category
  has_many :user_question_histories, dependent: :destroy

  def self.get_random_quiz(sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)
    return nil unless sub_category

    sub_category.sub_category_quizzes.order("RANDOM()").first
  end

  def self.submit_answer(user, sub_category_quiz_id, user_answer_index)
    quiz = find_by(id: sub_category_quiz_id)
    return { success: false, error: "Quiz not found", status: :not_found } if quiz.nil?

    is_correct_answer = (quiz.correct_answer_index == user_answer_index)

    begin
      ActiveRecord::Base.transaction do
        UserQuestionHistory.create!(
          user_id: user.id,
          sub_category_quiz_id: sub_category_quiz_id,
          is_correct_answer: is_correct_answer
        )

        if is_correct_answer
          sub_category_leaderboard = SubCategoryLeaderboard.find_or_initialize_by(
            user_id: user.id,
            sub_category_id: quiz.sub_category_id
          )
          sub_category_leaderboard.sub_category_points += 3
          sub_category_leaderboard.save!

          leaderboard = Leaderboard.find_or_initialize_by(user_id: user.id)
          leaderboard.points += 3
          leaderboard.save!
        end
      end
      { success: true, is_correct_answer: is_correct_answer }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, error: "Failed to save user answer", details: e.message, status: :unprocessable_entity }
    end
  end
end