class AllowNullSubCategoryIdInChallengeFriends < ActiveRecord::Migration[7.2]
  def change
    change_column_null :challenge_friends, :sub_category_id, true
  end
end
