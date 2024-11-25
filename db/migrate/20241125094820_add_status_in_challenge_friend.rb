class AddStatusInChallengeFriend < ActiveRecord::Migration[7.2]
  def change
    add_column :challenge_friends, :status, :string, null: false, default: 'pending'
  end
end
