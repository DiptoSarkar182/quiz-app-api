module ChallengeFriendSerializers
  class SentChallengeSerializer
    include JSONAPI::Serializer

    attributes :id, :challenger_id, :challengee_id, :amount_of_betting_coin

    attribute :challengee_full_name do |object|
      object.challengee.full_name
    end

    attribute :challengee_level do |object|
      object.challengee.level
    end

    attribute :profile_picture_url do |object|
      object.challengee.profile_picture_url
    end

  end
end