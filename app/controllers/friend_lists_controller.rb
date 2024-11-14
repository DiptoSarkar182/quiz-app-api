class FriendListsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @current_user_friend_lists = FriendList.current_user_friend_lists(current_user)

    if @current_user_friend_lists.any?
      render json: @current_user_friend_lists, status: :ok
    else
      render json: { message: "No friends found" }, status: :ok
    end
  end

  def add_friend
    result = FriendList.add_friend_in_friend_lists(current_user, params[:friend_id])

    render json: { message: result[:message] }, status: result[:status]
  end

  def remove_friend
    result = FriendList.remove_friend_from_friend_lists(current_user, params[:friend_id])

    render json: { message: result[:message] }, status: result[:status]
  end
end
