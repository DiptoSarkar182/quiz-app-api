# app/serializers/friend_request_serializers/received_friend_request_serializer.rb
module FriendRequestSerializers
  class ReceivedFriendRequestSerializer
    include JSONAPI::Serializer

    attributes :id, :sender_id

    attribute :full_name do |object|
      object.sender.full_name
    end

    attribute :profile_picture_url do |object|
      object.receiver.profile_picture_url
    end
  end
end
