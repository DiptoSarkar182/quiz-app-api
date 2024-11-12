class CreateSubCategoryLeaderboards < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_category_leaderboards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
      t.integer :sub_category_points, null: false, default: 0
      t.timestamps
    end
  end
end
