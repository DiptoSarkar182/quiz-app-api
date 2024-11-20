class SubCategoryLeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    result = SubCategoryLeaderboard.sub_category_leaderboard(params[:sub_category_id])

    if result[:status] == :ok
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: result[:status]
    end
  end
end
