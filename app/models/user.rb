class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
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

  def send_reset_password_otp
    token = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")
    self.reset_password_token = token
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    UserMailer.reset_password_instruction(self, self.reset_password_token).deliver_now
  end

  def verify_reset_password_otp(otp)
    self.reset_password_token == otp && self.reset_password_sent_at >= 5.minutes.ago
  end

  # Association
  has_one_attached :profile_picture
  has_one :leaderboard, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :sent_friend_requests, class_name: "FriendRequest", foreign_key: "sender_id", dependent: :destroy
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "receiver_id", dependent: :destroy
  has_many :friend_lists, dependent: :destroy
  has_many :friends, through: :friend_lists
  has_many :sub_category_followers, dependent: :destroy
  has_many :sub_categories, through: :sub_category_followers
  has_many :sub_category_leaderboards, dependent: :destroy
  has_many :user_question_histories, dependent: :destroy

  after_create :create_leaderboard_with_default_points
  after_create :create_default_settings

  def self.search_by_full_name_or_email(query)
    User.ransack(full_name_or_email_cont: query).result(distinct: true).select(:id, :full_name, :level)
  end

  def profile_picture_url
    # profile_picture.attached? ? url_for(profile_picture) : nil
    profile_picture.url if profile_picture.attached?
  end

  def self.get_profile_info(user_id)
    user = find_by(id: user_id)
    return nil unless user

    total_points = user.leaderboard.points
    highest_point = user.sub_category_leaderboards.maximum(:sub_category_points) || 0

    {
      id: user.id,
      full_name: user.full_name,
      level: user.level,
      total_points: total_points,
      highest_point_on_particular_subcategory: highest_point
    }
  end

  private

  def create_leaderboard_with_default_points
    create_leaderboard!(points: 0)
  end

  def create_default_settings
    create_setting!(daily_update: true, new_topic: true, new_tournament: true)
  end
end
