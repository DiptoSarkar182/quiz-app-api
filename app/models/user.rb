class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def self.ransackable_attributes(auth_object = nil)
    ["full_name", "email"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["friend_lists", "friends", "leaderboard", "received_friend_requests", "sent_friend_requests", "setting", "sub_categories", "sub_category_followers"]
  end

  OTP_LENGTH = 6

  def send_confirmation_instructions
    token = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")
    self.confirmation_token = token
    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
    UserMailer.confirmation_instructions(self, self.confirmation_token).deliver_now
  end

  # Association
  has_one :leaderboard, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :friend_lists, dependent: :destroy
  has_many :friends, through: :friend_lists
  has_many :sub_category_followers, dependent: :destroy
  has_many :sub_categories, through: :sub_category_followers
  has_many :sub_category_leaderboards, dependent: :destroy

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
