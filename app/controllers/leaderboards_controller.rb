class LeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def top_three_users
    time_range = determine_time_range(params[:range])
    @top_three_users = Leaderboard.top_three_users(time_range)

    if @top_three_users.any?
      render json: @top_three_users
    else
      render json: { message: "No top three users available for the selected range" }, status: :ok
    end
  end

  def leaderboards
    time_range = determine_time_range(params[:range])
    @leaderboards = Leaderboard.leaderboards_excluding_top_three(time_range)

    if @leaderboards.any?
      render json: @leaderboards
    else
      render json: { message: "No leaderboard available for the selected range" }, status: :ok
    end
  end

  private
  def determine_time_range(range)
    case range
    when "daily"
      1.day.ago
    when "weekly"
      7.days.ago
    when "monthly"
      30.days.ago
    else
      30.days.ago
    end
  end
end
