class CreateSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :daily_update
      t.boolean :new_topic
      t.boolean :new_tournament
      t.timestamps
    end
  end
end
