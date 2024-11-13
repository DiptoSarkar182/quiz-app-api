class Leaderboard < ApplicationRecord

  # Association
  belongs_to :user

  def self.top_three_users(time_range)
    joins(:user)
      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
      .where("leaderboards.updated_at >= ?", time_range)
      .order(points: :desc)
      .limit(3)
  end

  def self.leaderboards_excluding_top_three(time_range)
    top_three_user_ids = top_three_users(time_range).pluck("users.id")

    joins(:user)
      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
      .where("leaderboards.updated_at >= ?", time_range)
      .where.not(user_id: top_three_user_ids)
      .order(points: :desc)
  end
end
