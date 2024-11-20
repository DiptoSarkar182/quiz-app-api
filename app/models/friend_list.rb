class FriendList < ApplicationRecord

  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: 'friend_id'

  def self.current_user_friend_lists(user)
    user.friends
        .select("friend_lists.id AS id, friend_lists.user_id, users.id AS friend_id, users.full_name, users.level")
        .order("users.full_name")
  end

  def self.add_friend_in_friend_lists(current_user, friend_id)
    friend = User.find_by(id: friend_id)

    if friend.nil?
      return { status: :not_found, message: "The user you are trying to add does not exist" }
    end

    if current_user.id == friend_id
      return { status: :unprocessable_entity, message: "You can't add yourself as a friend" }
    end

    # Check if a friend request exists where the current user is the receiver
    request = FriendRequest.find_by(sender_id: friend_id, receiver_id: current_user.id)
    if request.nil?
      return { status: :unprocessable_entity, message: "You need to receive a friend request from this user to add them" }
    end

    # Proceed to add to the friend list since the request exists and current_user is accepting it
    ActiveRecord::Base.transaction do
      # Add current_user and friend_id as friends
      current_user.friend_lists.create!(friend_id: friend_id)
      friend.friend_lists.create!(friend_id: current_user.id)

      # Optionally, destroy the friend request after accepting
      request.destroy
    end

    { status: :ok, message: "Friend added successfully" }
  end



  def self.remove_friend_from_friend_lists(current_user, friend_id)
    friend_relationship = current_user.friend_lists.find_by(friend_id: friend_id)
    reverse_relationship = FriendList.find_by(user_id: friend_id, friend_id: current_user.id)

    if friend_relationship.nil? || reverse_relationship.nil?
      return { status: :not_found, message: "This friend relationship does not exist" }
    end

    ActiveRecord::Base.transaction do
      friend_relationship.destroy!
      reverse_relationship.destroy!
    end

    { status: :ok, message: "Friend removed successfully" }
  end
end
