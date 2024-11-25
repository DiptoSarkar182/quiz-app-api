class ChallengeFriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def sent_challenges
    sent_challenges = ChallengeFriend.current_user_sent_challenges(current_user)

    if sent_challenges.any?
      render json: sent_challenges
    else
      render json: { message: "No sent challenges found" }, status: :bad_request
    end
  end

  def received_challenges
    received_challenges = ChallengeFriend.current_user_received_challenges(current_user)

    if received_challenges.any?
      render json: received_challenges
    else
      render json: { message: "No received challenges found" }, status: :bad_request
    end
  end

  def send_challenge
    result = ChallengeFriend.send_challenge(current_user, challenge_params)

    render json: { message: result[:message], error: result[:error] }, status: result[:status]
  end

  def cancel_challenge
    result = ChallengeFriend.cancel_challenge(current_user, params[:challenge_id])

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  private
  def challenge_params
    params.require(:challenge_friend).permit(:friend_id, :sub_category_id, :amount_of_betting_coin, :challenge_type, :number_of_questions)
  end
end
