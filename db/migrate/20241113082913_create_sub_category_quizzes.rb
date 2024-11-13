class CreateSubCategoryQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_category_quizzes do |t|
      t.references :sub_category, null: false, foreign_key: true
      t.string :quiz_question, null: false, default: ''
      t.jsonb :quiz_options, default: []
      t.integer :correct_answer_index, null: false
      t.timestamps
    end
  end
end
