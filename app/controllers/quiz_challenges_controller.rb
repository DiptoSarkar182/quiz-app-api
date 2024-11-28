class QuizChallengesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :authenticate_admin!, only: [:create, :update_quiz_challenge, :delete_quiz_challenge]
  before_action :check_token_expiration


  def index
    render json: QuizChallenge.all
  end

  def create
    result = QuizChallenge.create_quiz_challenge(quiz_challenge_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data]}, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def update_quiz_challenge
    result = QuizChallenge.update_quiz_challenge(quiz_challenge_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def delete_quiz_challenge
    result = QuizChallenge.delete_quiz_challenge(quiz_challenge_params[:quiz_challenge_id])

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  private

  def quiz_challenge_params
    params.require(:quiz_challenge).permit(:quiz_challenge_id, :title, :prize, :entry_fee, subcategory_ids: [])
  end
end
