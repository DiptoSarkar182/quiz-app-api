class SubCategoryQuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    sub_category_id = params[:sub_category_id]

    sub_category = SubCategory.find_by(id: sub_category_id)
    if sub_category
      quiz = sub_category.sub_category_quizzes.order("RANDOM()").first

      if quiz
        render json: {
          id: quiz.id,
          sub_category_id: quiz.sub_category.id,
          quiz_question: quiz.quiz_question,
          quiz_options: quiz.quiz_options,
        }
      else
        render json: { error: "No quiz found for this subcategory" }, status: :not_found
      end
    else
      render json: { error: "Subcategory not found" }, status: :not_found
    end
  end

  def answer
    sub_category_quiz_id = params[:sub_category_quiz_id]
    user_answer_index = params[:correct_answer_index].to_i

    quiz = SubCategoryQuiz.find_by(id: sub_category_quiz_id)
    if quiz.nil?
      render json: { error: "Quiz not found" }, status: :not_found
      return
    end

    is_correct_answer = (quiz.correct_answer_index == user_answer_index)

    ActiveRecord::Base.transaction do
      UserQuestionHistory.create!(
        user_id: current_user.id,
        sub_category_quiz_id: sub_category_quiz_id,
        is_correct_answer: is_correct_answer
      )

      if is_correct_answer
        sub_category_leaderboard = SubCategoryLeaderboard.find_or_initialize_by(
          user_id: current_user.id,
          sub_category_id: quiz.sub_category_id
        )
        sub_category_leaderboard.sub_category_points += 3
        sub_category_leaderboard.save!

        leaderboard = Leaderboard.find_or_initialize_by(user_id: current_user.id)
        leaderboard.points += 3
        leaderboard.save!
      end
    end

    render json: { message: "Answer submitted successfully", is_correct_answer: is_correct_answer }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Failed to save user answer", details: e.message }, status: :unprocessable_entity
  end
end
