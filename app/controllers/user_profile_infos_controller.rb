class UserProfileInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    user = User.find_by(id: params[:user_id])

    if user
      total_points = user.leaderboard.points

      highest_point = SubCategoryLeaderboard.where(user_id: user.id).maximum(:sub_category_points)

      user_profile = {
        id: user.id,
        full_name: user.full_name,
        level: user.level,
        total_points: total_points,
        highest_point_on_particular_subcategory: highest_point || 0
      }

      render json: user_profile, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
