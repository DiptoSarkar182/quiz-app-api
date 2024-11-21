class SubCategoryQuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    sub_category_id = params[:sub_category_id]
    result = SubCategoryQuiz.get_random_quiz(sub_category_id)

    if result[:status] == :ok
      render json: result[:data], status: :ok
    else
      render json: { message: result[:message], errors: result[:errors] }, status: result[:status]
    end
  end

  def create
    result = SubCategoryQuiz.create_sub_category_quiz(sub_category_quiz_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :created
    else
      render json: { message: result[:message], errors: result[:errors] }, status: result[:status]
    end
  end

  def update_sub_category_quiz
    sub_category_quiz_params_with_extra = sub_category_quiz_params.merge(sub_category_quiz_id: params[:sub_category_quiz][:sub_category_quiz_id])
    result = SubCategoryQuiz.update_sub_category_quiz(sub_category_quiz_params_with_extra)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :ok
    else
      render json: { message: result[:message], errors: result[:errors] }, status: result[:status]
    end
  end

  def delete_sub_category_quiz
    result = SubCategoryQuiz.delete_sub_category_quiz(params[:sub_category_quiz_id])

    if result[:status] == :ok
      render json: { message: result[:message]}, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
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

  private
  def sub_category_quiz_params
    params.require(:sub_category_quiz).permit(:sub_category_id, :quiz_question, :correct_answer_index, quiz_options: [])
  end
end
