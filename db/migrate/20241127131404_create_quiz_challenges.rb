class CreateQuizChallenges < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_challenges do |t|
      t.string :title, null: false
      t.integer :prize, null: false
      t.integer :entry_fee, null: false
      t.integer :sub_category_ids, array: true, null: false, default: []
      t.timestamps
    end
  end
end
