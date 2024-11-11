class AddTotalFollowerInSubCategory < ActiveRecord::Migration[7.2]
  def change
    add_column :sub_categories, :total_follower, :integer, default: 0
  end
end
