class FriendList < ApplicationRecord

  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: 'friend_id', dependent: :destroy
end
