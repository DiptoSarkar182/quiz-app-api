class CreateSubCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_categories do |t|
      t.references :category, foreign_key: true, null: false
      t.string :title
      t.timestamps
    end
  end
end
