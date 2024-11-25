# app/serializers/friend_request_serializers/sent_friend_request_serializer.rb
module FriendRequestSerializers
  class SentFriendRequestSerializer
    include JSONAPI::Serializer

    attributes :id, :receiver_id

    attribute :full_name do |object|
      object.receiver.full_name
    end

    attribute :profile_picture_url do |object|
      object.receiver.profile_picture_url
    end
  end
end
