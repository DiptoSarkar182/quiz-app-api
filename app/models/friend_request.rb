class FriendRequest < ApplicationRecord

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def self.current_user_sent_friend_requests(user)
    user.sent_friend_requests.map do |request|
      {
        id: request.id,
        receiver_id: request.receiver.id,
        full_name: request.receiver.full_name
      }
    end
  end

  def self.current_user_received_friend_requests(user)
    user.received_friend_requests.map do |request|
      {
        request_id: request.id,
        sender_id: request.sender.id,
        full_name: request.sender.full_name
      }
    end
  end

  def self.create_request(sender, receiver_id)
    receiver = User.find_by(id: receiver_id)
    return { status: :not_found, message: "The user you are trying to send a request to does not exist" } if receiver.nil?

    if sender.id == receiver_id
      return { status: :unprocessable_entity, message: "You cannot send a friend request to yourself" }
    end

    if sender.friend_lists.exists?(friend_id: receiver_id) || receiver.friend_lists.exists?(friend_id: sender.id)
      return { status: :unprocessable_entity, message: "You are already friends with this user" }
    end

    if sender.sent_friend_requests.exists?(receiver_id: receiver_id)
      return { status: :unprocessable_entity, message: "Friend request already sent to this user" }
    end

    if receiver.sent_friend_requests.exists?(receiver_id: sender.id)
      return { status: :unprocessable_entity, message: "You have already received a friend request from this user" }
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

    if receiver.nil?
      return { status: :not_found, message: "The user you are trying to cancel the request with does not exist" }
    end

    if sender.friend_lists.exists?(friend_id: receiver_id) || receiver.friend_lists.exists?(friend_id: sender.id)
      return { status: :unprocessable_entity, message: "You are already friends with this user, the request cannot be canceled" }
    end

    friend_request = sender.sent_friend_requests.find_by(receiver_id: receiver_id)

    if friend_request.nil?
      return { status: :not_found, message: "No friend request found to cancel" }
    end

    if friend_request.destroy
      { status: :ok, message: "Friend request canceled successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to cancel the friend request", errors: friend_request.errors.full_messages }
    end
  end

  def self.decline_request(receiver, sender_id)
    sender = User.find_by(id: sender_id)

    if sender.nil?
      return { status: :not_found, message: "The user you are trying to decline the request from does not exist" }
    end

    friend_request = receiver.received_friend_requests.find_by(sender_id: sender_id)

    if friend_request.nil?
      return { status: :not_found, message: "No friend request found to decline" }
    end

    if friend_request.destroy
      { status: :ok, message: "Friend request declined successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to decline the friend request", errors: friend_request.errors.full_messages }
    end
  end

end
