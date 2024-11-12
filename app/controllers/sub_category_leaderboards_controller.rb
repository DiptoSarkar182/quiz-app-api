class SubCategoryLeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    sub_category = SubCategory.find_by(id: params[:sub_category_id])

    if sub_category
      leaderboard = SubCategoryLeaderboard
                      .where(sub_category_id: sub_category.id)
                      .joins(:user)
                      .select('sub_category_leaderboards.id', 'users.id AS user_id', 'users.full_name', 'users.level', 'sub_category_leaderboards.sub_category_points')
                      .order('sub_category_leaderboards.sub_category_points DESC')

      render json: leaderboard, status: :ok
    else
      render json: { error: 'Subcategory not found' }, status: :not_found
    end
  end
end
