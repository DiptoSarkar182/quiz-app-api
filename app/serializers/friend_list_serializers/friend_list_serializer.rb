# app/serializers/friend_list_serializers/friend_list_serializer.rb
module FriendListSerializers
  class FriendListSerializer
    include JSONAPI::Serializer

    attributes :id, :user_id, :friend_id

    attribute :full_name do |object|
      object.friend.full_name
    end

    attribute :level do |object|
      object.friend.level
    end

    attribute :profile_picture_url do |object|
      object.friend.profile_picture_url
    end
  end
end
