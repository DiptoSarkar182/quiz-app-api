class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration


  def current_user_sent_friend_requests
    sent_requests = FriendRequest.current_user_sent_friend_requests(current_user)

    if sent_requests.any?
      sent_requests_with_profile_pictures = sent_requests.map do |request|
        profile_picture_url = request.receiver.profile_picture.attached? ? url_for(request.receiver.profile_picture) : nil
        {
          id: request.id,
          receiver_id: request.receiver_id,
          full_name: request.receiver.full_name,
          profile_picture_url: profile_picture_url
        }
      end
      render json: sent_requests_with_profile_pictures, status: :ok
    else
      render json: { message: "No sent requests" }, status: :ok
    end
  end

  def current_user_received_friend_requests
    received_requests = FriendRequest.current_user_received_friend_requests(current_user)

    if received_requests.any?
      received_requests_with_profile_pictures = received_requests.map do |request|
        profile_picture_url = request.sender.profile_picture.attached? ? url_for(request.sender.profile_picture) : nil
        {
          id: request.id,
          sender_id: request.sender_id,
          full_name: request.sender.full_name,
          profile_picture_url: profile_picture_url
        }
      end
      render json: received_requests_with_profile_pictures, status: :ok
    else
      render json: { message: "No received requests" }, status: :ok
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
      users_with_profile_pictures = @users.map do |user|
        profile_picture_url = user.profile_picture.attached? ? url_for(user.profile_picture) : nil
        {
          id: user.id,
          full_name: user.full_name,
          level: user.level,
          profile_picture_url: profile_picture_url
        }
      end
      render json: users_with_profile_pictures, status: :ok
    else
      render json: { message: "No user found" }, status: :not_found
    end
  end
end
