class FriendListsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @current_user_friend_lists = current_user.friends
                                             .select("friend_lists.id AS id, friend_lists.user_id, users.id AS friend_id, users.full_name, users.level")

    if @current_user_friend_lists.any?
      render json: @current_user_friend_lists, status: :ok
    else
      render json: { message: "No friends found" }, status: :ok
    end
  end

  def add_friend
    friend_id = params[:friend_id]

    friend = User.find_by(id: friend_id)
    if friend.nil?
      return render json: { message: "The user you are trying to add does not exist" }, status: :not_found
    end

    if current_user.id == friend_id
      return render json: { message: "You can't add yourself as a friend" }, status: :unprocessable_entity
    end

    if current_user.friends.exists?(friend_id)
      return render json: { message: "This user is already in your friend lists" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      current_user.friend_lists.create!(friend_id: friend_id)
      User.find(friend_id).friend_lists.create!(friend_id: current_user.id)
    end

    render json: { message: "Friend added successfully" }, status: :ok
  end

  def remove_friend
    friend_id = params[:friend_id]

    friend_relationship = current_user.friend_lists.find_by(friend_id: friend_id)
    reverse_relationship = FriendList.find_by(user_id: friend_id, friend_id: current_user.id)

    if friend_relationship.nil? || reverse_relationship.nil?
      return render json: { message: "This friend relationship does not exist" }, status: :not_found
    end

    ActiveRecord::Base.transaction do
      friend_relationship.destroy!
      reverse_relationship.destroy!
    end

    render json: { message: "Friend removed successfully" }, status: :ok
  end
end
