class CreateFriendLists < ActiveRecord::Migration[7.2]
  def change
    create_table :friend_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :friend_lists, [:user_id, :friend_id], unique: true
  end
end
