class CreateLeaderboards < ActiveRecord::Migration[7.2]
  def change
    create_table :leaderboards do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points, null: false, default: 0
      t.timestamps
    end
  end
end
