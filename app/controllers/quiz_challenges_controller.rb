class QuizChallengesController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_token_expiration

  def create
    result = QuizChallenge.create_quiz_challenge(quiz_challenge_params)

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  private

  def quiz_challenge_params
    params.require(:quiz_challenge).permit(:title, :prize, :entry_fee, subcategory_ids: [])
  end
end
