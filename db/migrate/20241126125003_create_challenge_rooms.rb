class CreateChallengeRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :challenge_rooms do |t|
      t.references :challenge_friend, null: false, foreign_key: true
      t.integer :total_question, null: false
      t.integer :total_betting_coins, null: false
      t.timestamps
    end
  end
end
