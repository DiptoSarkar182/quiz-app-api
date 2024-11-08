class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration


  def current_user_sent_friend_requests
    sent_requests = current_user.sent_friend_requests.map do |request|
      {
        id: request.id,
        receiver_id: request.receiver.id,
        full_name: request.receiver.full_name
      }
    end

    if sent_requests.any?
      render json: sent_requests
    else
      render json: { message: "No sent requests" }
    end
  end

  def current_user_received_friend_requests
    received_requests = current_user.received_friend_requests.map do |request|
      {
        request_id: request.id,
        sender_id: request.sender.id,
        full_name: request.sender.full_name
      }
    end

    if received_requests.any?
      render json: received_requests
    else
      render json: { message: "No received request" }
    end
  end

  def send_friend_request
    receiver_id = params[:receiver_id]
    receiver = User.find_by(id: receiver_id)

    if receiver.nil?
      return render json: { message: "The user you are trying to send a request to does not exist" }, status: :not_found
    end

    if current_user.id == receiver_id
      return render json: { message: "You cannot send a friend request to yourself" }, status: :unprocessable_entity
    end

    if current_user.friend_lists.exists?(friend_id: receiver_id) || receiver.friend_lists.exists?(friend_id: current_user.id)
      return render json: { message: "You are already friends with this user" }, status: :unprocessable_entity
    end

    if current_user.sent_friend_requests.exists?(receiver_id: receiver_id)
      return render json: { message: "Friend request already sent to this user" }, status: :unprocessable_entity
    end

    if receiver.sent_friend_requests.exists?(receiver_id: current_user.id)
      return render json: { message: "You have already received a friend request from this user" }, status: :unprocessable_entity
    end

    friend_request = current_user.sent_friend_requests.new(receiver: receiver)

    if friend_request.save
      render json: { message: "Friend request sent successfully" }, status: :ok
    else
      render json: { message: "Failed to send friend request", errors: friend_request.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def cancel_friend_request
    receiver_id = params[:receiver_id]
    receiver = User.find_by(id: receiver_id)

    if receiver.nil?
      return render json: { message: "The user you are trying to cancel the request with does not exist" }, status: :not_found
    end

    if current_user.friend_lists.exists?(friend_id: receiver_id) || receiver.friend_lists.exists?(friend_id: current_user.id)
      return render json: { message: "You are already friends with this user, the request cannot be canceled" }, status: :unprocessable_entity
    end

    friend_request = current_user.sent_friend_requests.find_by(receiver_id: receiver_id)

    if friend_request.nil?
      return render json: { message: "No friend request found to cancel" }, status: :not_found
    end

    if friend_request.destroy
      render json: { message: "Friend request canceled successfully" }, status: :ok
    else
      render json: { message: "Failed to cancel the friend request", errors: friend_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
