class AddCascadeDeleteToFriendLists < ActiveRecord::Migration[7.2]
  def change
    # Assuming your foreign key is on user_id and friend_id
    remove_foreign_key :friend_lists, :users, column: :user_id
    remove_foreign_key :friend_lists, :users, column: :friend_id

    add_foreign_key :friend_lists, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :friend_lists, :users, column: :friend_id, on_delete: :cascade
  end
end
