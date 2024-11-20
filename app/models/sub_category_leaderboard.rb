class SubCategoryLeaderboard < ApplicationRecord

  belongs_to :user
  belongs_to :sub_category

  def self.sub_category_leaderboard(sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)
    if sub_category
      leaderboard = SubCategoryLeaderboard
                      .where(sub_category_id: sub_category.id)
                      .joins(:user)
                      .select('sub_category_leaderboards.id', 'users.id AS user_id', 'users.full_name', 'users.level', 'sub_category_leaderboards.sub_category_points')
                      .order('sub_category_leaderboards.sub_category_points DESC')

      { status: :ok, data: leaderboard }
    else
      { status: :not_found, message: "Subcategory not found" }
    end
  end
end
