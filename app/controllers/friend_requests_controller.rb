class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration


  def current_user_sent_friend_requests
    sent_requests = FriendRequest.current_user_sent_friend_requests(current_user)

    if sent_requests.any?
      render json: sent_requests
    else
      render json: { message: "No sent requests" }
    end
  end

  def current_user_received_friend_requests
    received_requests = FriendRequest.current_user_received_friend_requests(current_user)

    if received_requests.any?
      render json: received_requests
    else
      render json: { message: "No received request" }
    end
  end

  def send_friend_request
    result = FriendRequest.create_request(current_user, params[:receiver_id])

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end


  def cancel_friend_request
    result = FriendRequest.cancel_request(current_user, params[:receiver_id])

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def decline_friend_request
    result = FriendRequest.decline_request(current_user, params[:sender_id])

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def find_friend
    @users = User.search_by_full_name_or_email(params[:query])

    if @users.any?
      render json: @users.as_json(only: [:id, :full_name, :level])
    else
      render json: { message: "No user found" }, status: :not_found
    end
  end
end
