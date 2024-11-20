class SubCategoryQuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    sub_category_id = params[:sub_category_id]
    quiz = SubCategoryQuiz.get_random_quiz(sub_category_id)

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
  end

  def answer
    sub_category_quiz_id = params[:sub_category_quiz_id]
    user_answer_index = params[:correct_answer_index].to_i

    result = SubCategoryQuiz.submit_answer(current_user, sub_category_quiz_id, user_answer_index)

    if result[:success]
      render json: { message: "Answer submitted successfully", is_correct_answer: result[:is_correct_answer] }, status: :ok
    else
      render json: { error: result[:error], details: result[:details] }, status: result[:status]
    end
  end
end