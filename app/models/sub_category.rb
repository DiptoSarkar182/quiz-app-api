class SubCategory < ApplicationRecord

  belongs_to :category

  has_many :sub_category_followers, dependent: :destroy
  has_many :users, through: :sub_category_followers
  has_many :sub_category_leaderboards, dependent: :destroy
end
