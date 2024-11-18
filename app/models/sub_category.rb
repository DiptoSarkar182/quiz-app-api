class SubCategory < ApplicationRecord

  belongs_to :category

  has_many :sub_category_followers, dependent: :destroy
  has_many :users, through: :sub_category_followers
  has_many :sub_category_leaderboards, dependent: :destroy
  has_many :sub_category_quizzes, dependent: :destroy

  def self.sub_categories_for_category(category_id)
    category = Category.find_by(id: category_id)

    if category
      { status: :ok, data: category.sub_categories }
    else
      { status: :not_found, message: "Category not found" }
    end
  end

  def self.top_sub_categories_list
    where("total_follower > 0").order(total_follower: :desc).limit(10)
  end

end
