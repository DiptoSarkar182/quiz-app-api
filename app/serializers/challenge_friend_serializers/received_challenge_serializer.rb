module ChallengeFriendSerializers
  class ReceivedChallengeSerializer
    include JSONAPI::Serializer

    attributes :id, :challenger_id, :challengee_id, :amount_of_betting_coin

    attribute :challenger_full_name do |object|
      object.challenger.full_name
    end

    attribute :challenger_level do |object|
      object.challenger.level
    end

    attribute :profile_picture_url do |object|
      object.challenger.profile_picture_url
    end

  end
end