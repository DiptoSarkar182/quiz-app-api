class ChallengeFriend < ApplicationRecord

  has_one :challenge_room, dependent: :destroy
  belongs_to :challenger, class_name: 'User'
  belongs_to :challengee, class_name: 'User'
  belongs_to :sub_category, optional: true
  validates :sub_category, presence: true, if: -> { challenge_type == 'single_subject' }
  validates :challenge_type, presence: true

  def self.current_user_sent_challenges(user)
    sent_challenges = ChallengeFriend.where(challenger_id: user.id)
    ChallengeFriendSerializers::SentChallengeSerializer
      .new(sent_challenges)
      .serializable_hash[:data]
      .map { |request| request[:attributes] }
  end

  def self.current_user_received_challenges(user)
    received_challenges = ChallengeFriend.where(challengee_id: user.id)
    ChallengeFriendSerializers::ReceivedChallengeSerializer
      .new(received_challenges)
      .serializable_hash[:data]
      .map { |request| request[:attributes] }
  end

  def self.send_challenge(user, params)
    friend = User.find_by(id: params[:friend_id])

    return { message: 'Friend not found', status: :not_found } if friend.nil?
    return { message: 'You cannot challenge yourself', status: :unprocessable_entity } if user == friend
    return { message: 'User not in your friend list', status: :unprocessable_entity } unless user.friends.include?(friend)

    if params[:challenge_type] == 'single_subject'
      sub_category = SubCategory.find_by(id: params[:sub_category_id])
      return { message: 'Subcategory not found', status: :not_found } if sub_category.nil?
    end
    challenge_type = params[:challenge_type]
    existing_pending_challenge = ChallengeFriend
                                   .where(challenger: user, challengee: friend)
                                   .or(ChallengeFriend.where(challenger: friend, challengee: user)
                                                      .where(challenge_type: challenge_type, sub_category: sub_category, status: 'pending'))


    if existing_pending_challenge.exists?
      return { message: "A pending #{params[:challenge_type]} challenge already exists between you and the user", status: :unprocessable_entity }
    end

    return { message: 'Invalid challenge type', status: :unprocessable_entity } unless %w[single_subject global].include?(params[:challenge_type])

    if user.coins < params[:amount_of_betting_coin].to_i
      return { message: 'Not enough betting coins', status: :unprocessable_entity }
    end

    ActiveRecord::Base.transaction do
      ChallengeFriend.create!(
        challenger: user,
        challengee: friend,
        sub_category: params[:challenge_type] == 'single_subject' ? sub_category : nil,
        amount_of_betting_coin: params[:amount_of_betting_coin],
        challenge_type: params[:challenge_type],
        number_of_questions: params[:number_of_questions]
      )

      user.decrement_coins!(params[:amount_of_betting_coin].to_i)

      { message: 'Challenge sent successfully', status: :ok }
    end
  rescue ActiveRecord::RecordInvalid => e
    { message: 'Failed to send challenge', status: :unprocessable_entity }
  end



  def self.cancel_challenge(user, challenge_id)
    challenge = ChallengeFriend.find_by(id: challenge_id, challenger: user, status: 'pending')

    if challenge.nil?
      return { message: 'Challenge not found, or you are not the challenger, or the challenge is not pending', status: :not_found }
    end

    ActiveRecord::Base.transaction do
      user.increment_coins!(params[:amount_of_betting_coin].to_i)
      challenge.destroy!
    end
    { message: 'Challenge cancelled and betting coins refunded successfully', status: :ok }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    { message: 'Failed to cancel challenge', status: :unprocessable_entity }
  end

  def self.accept_challenge_request(user, challenge_id)
    challenge = ChallengeFriend.find_by(id: challenge_id, challengee: user, status: 'pending')

    return { message: 'Challenge not found or not eligible for acceptance', status: :not_found } if challenge.nil?

    if user.coins < challenge.amount_of_betting_coin
      return { message: 'Insufficient coins to accept this challenge', status: :unprocessable_entity }
    end

    ActiveRecord::Base.transaction do
      user.decrement_coins!(params[:amount_of_betting_coin].to_i)
      challenge.update!(status: 'accepted')
      ChallengeRoom.create!(challenge_friend: challenge,
                            total_question: challenge.number_of_questions,
                            total_betting_coins: challenge.amount_of_betting_coin * 2)
    end

    { message: 'Challenge accepted and coins deducted successfully', status: :ok }
  rescue ActiveRecord::RecordInvalid => e
    { message: 'Failed to accept challenge due to validation error', status: :unprocessable_entity }
  rescue ActiveRecord::StatementInvalid => e
    { message: 'Failed to accept challenge due to database error', status: :unprocessable_entity }
  end

  def self.reject_challenge_request(user, challenge_id)
    challenge = ChallengeFriend.find_by(id: challenge_id, challengee: user, status: 'pending')

    return { message: 'Challenge not found', status: :not_found } if challenge.nil?

    ActiveRecord::Base.transaction do
      challenge.challenger.increment_coins!(challenge.amount_of_betting_coin)
      user.increment_coins!(challenge.amount_of_betting_coin)
      challenge.update!(status: 'rejected')
    end

    { message: 'Challenge rejected successfully', status: :ok }
  rescue ActiveRecord::RecordInvalid => e
    { message: "Failed to reject challenge due to validation error: #{e.message}", status: :unprocessable_entity }
  rescue ActiveRecord::StatementInvalid => e
    { message: "Failed to reject challenge due to database error: #{e.message}", status: :unprocessable_entity }
  end



end
