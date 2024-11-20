class Leaderboard < ApplicationRecord

  # Association
  belongs_to :user

  def self.top_three_users(range)
    time_range = determine_time_range(range)
    joins(:user)
      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
      .where("leaderboards.updated_at >= ?", time_range)
      .order(points: :desc)
      .limit(3)
  end

  def self.leaderboards_excluding_top_three(range)
    time_range = determine_time_range(range)
    top_three_user_ids = top_three_users(range).pluck("users.id")

    joins(:user)
      .select("leaderboards.id, users.id AS user_id, users.full_name, leaderboards.points, leaderboards.created_at, leaderboards.updated_at")
      .where("leaderboards.updated_at >= ?", time_range)
      .where.not(user_id: top_three_user_ids)
      .order(points: :desc)
  end

  private

  def self.determine_time_range(range)
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
