class LeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def top_three_users
    @top_three_users = Leaderboard.top_three_users(params[:range])

    if @top_three_users.any?
      render json: @top_three_users
    else
      render json: { message: "No top three users available for the selected range" }, status: :ok
    end
  end

  def leaderboards
    @leaderboards = Leaderboard.leaderboards_excluding_top_three(params[:range])

    if @leaderboards.any?
      render json: @leaderboards
    else
      render json: { message: "No leaderboard available for the selected range" }, status: :ok
    end
  end

end
