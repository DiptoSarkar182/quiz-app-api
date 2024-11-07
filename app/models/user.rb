class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Association
  has_one :leaderboard

  # After user creation, create the leaderboard with 0 points
  after_create :create_leaderboard_with_default_points

  private

  def create_leaderboard_with_default_points
    create_leaderboard!(points: 0)
  end
end
