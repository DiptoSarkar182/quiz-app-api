class LeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @leaderboards = Leaderboard.joins(:user)
                               .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                               .order(points: :desc)

    top_three_user_ids = Leaderboard.joins(:user)
                                    .select("users.id")
                                    .order(points: :desc)
                                    .limit(3)
                                    .pluck(:user_id)

    @leaderboards = @leaderboards.where.not(user_id: top_three_user_ids)

    if @leaderboards.any?
      render json: @leaderboards
    else
      render json: { message: 'No leaderboards available' }, status: :ok
    end
  end

  def top_three_users
    @top_three_users = Leaderboard.joins(:user)
                                  .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                  .order(points: :desc)
                                  .limit(3)
    if @top_three_users.any?
      render json: @top_three_users
    else
      render json: { message: 'No top users available' }, status: :ok
    end
  end

end
