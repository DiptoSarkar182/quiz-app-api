class FriendRequest < ApplicationRecord

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def self.current_user_sent_friend_requests(user)
    user.sent_friend_requests.includes(:receiver)
  end

  def self.current_user_received_friend_requests(user)
    user.received_friend_requests.includes(:sender)
  end

  def self.create_request(sender, receiver_id)
    receiver = User.find_by(id: receiver_id)
    return { status: :not_found, message: "The user you are trying to send a request to does not exist" } if receiver.nil?

    if invalid_request?(sender, receiver)
      return invalid_request_response(sender, receiver)
    end

    friend_request = sender.sent_friend_requests.new(receiver: receiver)
    if friend_request.save
      { status: :ok, message: "Friend request sent successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to send friend request", errors: friend_request.errors.full_messages }
    end
  end

  def self.cancel_request(sender, receiver_id)
    receiver = User.find_by(id: receiver_id)
    return { status: :not_found, message: "The user you are trying to cancel the request with does not exist" } if receiver.nil?

    if already_friends?(sender, receiver)
      return { status: :unprocessable_entity, message: "You are already friends with this user, the request cannot be canceled" }
    end

    friend_request = sender.sent_friend_requests.find_by(receiver_id: receiver_id)
    return { status: :not_found, message: "No friend request found to cancel" } if friend_request.nil?

    if friend_request.destroy
      { status: :ok, message: "Friend request canceled successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to cancel the friend request", errors: friend_request.errors.full_messages }
    end
  end

  def self.decline_request(receiver, sender_id)
    sender = User.find_by(id: sender_id)
    return { status: :not_found, message: "The user you are trying to decline the request from does not exist" } if sender.nil?

    friend_request = receiver.received_friend_requests.find_by(sender_id: sender_id)
    return { status: :not_found, message: "No friend request found to decline" } if friend_request.nil?

    if friend_request.destroy
      { status: :ok, message: "Friend request declined successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to decline the friend request", errors: friend_request.errors.full_messages }
    end
  end

  private

  def self.invalid_request?(sender, receiver)
    sender.id == receiver.id ||
      already_friends?(sender, receiver) ||
      sender.sent_friend_requests.exists?(receiver_id: receiver.id) ||
      receiver.sent_friend_requests.exists?(receiver_id: sender.id)
  end

  def self.invalid_request_response(sender, receiver)
    if sender.id == receiver.id
      { status: :unprocessable_entity, message: "You cannot send a friend request to yourself" }
    elsif already_friends?(sender, receiver)
      { status: :unprocessable_entity, message: "You are already friends with this user" }
    elsif sender.sent_friend_requests.exists?(receiver_id: receiver.id)
      { status: :unprocessable_entity, message: "Friend request already sent to this user" }
    elsif receiver.sent_friend_requests.exists?(receiver_id: sender.id)
      { status: :unprocessable_entity, message: "You have already received a friend request from this user" }
    end
  end

  def self.already_friends?(sender, receiver)
    sender.friend_lists.exists?(friend_id: receiver.id) || receiver.friend_lists.exists?(friend_id: sender.id)
  end

end
