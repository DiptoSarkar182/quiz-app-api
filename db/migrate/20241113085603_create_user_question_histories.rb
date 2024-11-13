class CreateUserQuestionHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :user_question_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sub_category_quiz, null: false, foreign_key: true
      t.boolean :is_correct_answer
      t.timestamps
    end
  end
end
