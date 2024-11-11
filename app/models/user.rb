class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Association
  has_one :leaderboard, dependent: :destroy
  has_one :setting
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :friend_lists, dependent: :destroy
  has_many :friends, through: :friend_lists

  # After user creation, create the leaderboard with 0 points
  after_create :create_leaderboard_with_default_points
  after_create :create_default_settings

  private

  def create_leaderboard_with_default_points
    create_leaderboard!(points: 0)
  end

  def create_default_settings
    create_setting!(daily_update: true, new_topic: true, new_tournament: true)
  end
end
