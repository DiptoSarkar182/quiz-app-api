class CreateChallengeFriends < ActiveRecord::Migration[7.2]
  def change
    create_enum :challenge_type_enum, ["single_subject", "global"]

    create_table :challenge_friends do |t|
      t.references :challenger, null: false, foreign_key: { to_table: :users }
      t.references :challengee, null: false, foreign_key: { to_table: :users }
      t.references :sub_category, null: false, foreign_key: true
      t.integer :amount_of_betting_coin, null: false, default: 0
      t.enum :challenge_type, enum_type: :challenge_type_enum, null: false
      t.integer :number_of_questions, null: false, default: 0
      t.timestamps
    end
  end
end
