class LeaderboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def monthly_top_three_users
    @monthly_top_three_users = Leaderboard.joins(:user)
                                  .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                  .where("leaderboards.updated_at >= ?", 30.days.ago)
                                  .order(points: :desc)
                                  .limit(3)
    if @monthly_top_three_users.any?
      render json: @monthly_top_three_users
    else
      render json: { message: 'No monthly top three users available' }, status: :ok
    end
  end

  def monthly_leaderboards
    monthly_top_three_user_ids = Leaderboard.joins(:user)
                                    .where("leaderboards.updated_at >= ?", 30.days.ago)
                                    .order(points: :desc)
                                    .limit(3)
                                    .pluck("users.id")

    @monthly_leaderboards = Leaderboard.joins(:user)
                                       .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                       .where("leaderboards.updated_at >= ?", 30.days.ago)
                                       .where.not(user_id: monthly_top_three_user_ids)
                                       .order(points: :desc)

    if @monthly_leaderboards.any?
      render json: @monthly_leaderboards
    else
      render json: { message: 'No monthly leaderboard available' }, status: :ok
    end
  end

  def weekly_top_three_users
    @weekly_top_three_users = Leaderboard.joins(:user)
                                          .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                          .where("leaderboards.updated_at >= ?", 7.days.ago)
                                          .order(points: :desc)
                                          .limit(3)

    if @weekly_top_three_users.any?
      render json: @weekly_top_three_users
    else
      render json: { message: 'No weekly top three users available' }, status: :ok
    end
  end

  def weekly_leaderboards
    weekly_top_three_user_ids = Leaderboard.joins(:user)
                                           .where("leaderboards.updated_at >= ?", 7.days.ago)
                                           .order(points: :desc)
                                           .limit(3)
                                           .pluck("users.id")

    @weekly_leaderboards = Leaderboard.joins(:user)
                                      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                      .where("leaderboards.updated_at >= ?", 7.days.ago)
                                      .where.not(user_id: weekly_top_three_user_ids)
                                      .order(points: :desc)

    if @weekly_leaderboards.any?
      render json: @weekly_leaderboards
    else
      render json: { message: 'No weekly leaderboard available' }, status: :ok
    end
  end

  def daily_top_three_users
    @daily_top_three_users = Leaderboard.joins(:user)
                                         .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                         .where("leaderboards.updated_at >= ?", Time.zone.today)
                                         .order(points: :desc)
                                         .limit(3)

    if @daily_top_three_users.any?
      render json: @daily_top_three_users
    else
      render json: { message: 'No daily top three users available' }, status: :ok
    end
  end

  def daily_leaderboards
    daily_top_three_user_ids = Leaderboard.joins(:user)
                                           .where("leaderboards.updated_at >= ?", Time.zone.today)
                                           .order(points: :desc)
                                           .limit(3)
                                           .pluck("users.id")

    @daily_leaderboards = Leaderboard.joins(:user)
                                      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
                                      .where("leaderboards.updated_at >= ?", Time.zone.today)
                                      .where.not(user_id: daily_top_three_user_ids)
                                      .order(points: :desc)

    if @daily_leaderboards.any?
      render json: @daily_leaderboards
    else
      render json: { message: 'No daily leaderboard available' }, status: :ok
    end
  end

end
