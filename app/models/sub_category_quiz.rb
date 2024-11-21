class SubCategoryQuiz < ApplicationRecord
  belongs_to :sub_category
  has_many :user_question_histories, dependent: :destroy

  validates :quiz_question, presence: true
  validates :quiz_options, presence: true, length: { is: 4 }
  validates :correct_answer_index, presence: true

  def self.get_random_quiz(sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)
    return { status: :not_found, message: "Sub category not found" } unless sub_category

    quiz = sub_category.sub_category_quizzes.order("RANDOM()").first
    if quiz
      data = SubCategoryQuizSerializers::QuizSerializer.new(quiz).serializable_hash[:data][:attributes]
      { status: :ok, data: data }
    else
      { status: :not_found, message: "No quizzes found for this sub category" }
    end
  end


  def self.create_sub_category_quiz(params)
    sub_category = SubCategory.find_by(id: params[:sub_category_id])
    return { status: :not_found, message: "Sub category not found!" } if sub_category.nil?

    sub_category_quiz = SubCategoryQuiz.new(params)

    if sub_category_quiz.save
      { status: :ok, message: "Quiz created successfully", data: sub_category_quiz }
    else
      { status: :unprocessable_entity, message: "Failed to create quiz", errors: sub_category_quiz.errors.full_messages }
    end
  end

  def self.update_sub_category_quiz(params)
    sub_category_quiz = SubCategoryQuiz.find_by(id: params[:sub_category_quiz_id])
    return { status: :not_found, message: "Sub category quiz not found!" } if sub_category_quiz.nil?

    sub_category = SubCategory.find_by(id: params[:sub_category_id])
    return { status: :not_found, message: "Sub category not found!" } if sub_category.nil?

    if sub_category_quiz.update(params.except(:sub_category_quiz_id))
      { status: :ok, message: "Sub category quiz updated successfully", data: sub_category_quiz }
    else
      { status: :unprocessable_entity, message: "Failed to update sub category quiz", errors: sub_category_quiz.errors.full_messages }
    end
  end

  def self.delete_sub_category_quiz(sub_category_quiz_id)
    sub_category_quiz = SubCategoryQuiz.find_by(id: sub_category_quiz_id)
    return { status: :not_found, message: "Sub category quiz not found!" } unless sub_category_quiz

    if sub_category_quiz.destroy
      { status: :ok, message: "Sub category quiz deleted successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to delete sub category quiz", errors: sub_category_quiz.errors.full_messages }
    end
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