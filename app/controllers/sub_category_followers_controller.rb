class SubCategoryFollowersController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def follow
    result = SubCategoryFollower.follow_sub_category(current_user, params[:sub_category_id])

    if result[:status] == :ok
      render json: { message: result[:message], sub_category: result[:sub_category] }, status: :ok
    else
      render json: { message: result[:message]}, status: result[:status]
    end
  end

  def unfollow
    result = SubCategoryFollower.unfollow_sub_category(current_user, params[:sub_category_id])

    if result[:status] == :ok
      render json: { message: result[:message], sub_category: result[:sub_category] }, status: :ok
    else
      render json: { message: result[:message]}, status: result[:status]
    end
  end

end
