class CreateSubCategoryFollowers < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_category_followers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
