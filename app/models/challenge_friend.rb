class ChallengeFriend < ApplicationRecord

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

      existing_pending_challenge = ChallengeFriend.where(
        "(challenger_id = :user_id AND challengee_id = :friend_id) OR (challenger_id = :friend_id AND challengee_id = :user_id)",
        {
          user_id: user.id,
          friend_id: friend.id
        }
      ).where(
        sub_category: sub_category,
        challenge_type: 'single_subject',
        status: 'pending'
      ).exists?

      return { message: 'A pending challenge with this subcategory already exists between you and the user', status: :unprocessable_entity } if existing_pending_challenge
    elsif params[:challenge_type] == 'global'
      existing_pending_global_challenge = ChallengeFriend.where(
        "(challenger_id = :user_id AND challengee_id = :friend_id) OR (challenger_id = :friend_id AND challengee_id = :user_id)",
        {
          user_id: user.id,
          friend_id: friend.id
        }
      ).where(
        challenge_type: 'global',
        status: 'pending'
      ).exists?

      return { message: 'A pending global challenge already exists between you and the user', status: :unprocessable_entity } if existing_pending_global_challenge
    else
      return { message: 'Invalid challenge type', status: :unprocessable_entity }
    end

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
        number_of_questions: params[:number_of_questions],
      )

      user.update!(coins: user.coins - params[:amount_of_betting_coin].to_i)

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
      user.update!(coins: user.coins + challenge.amount_of_betting_coin)
      challenge.destroy!
    end
    { message: 'Challenge cancelled and betting coins refunded successfully', status: :ok }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    { message: 'Failed to cancel challenge', status: :unprocessable_entity }
  end
end
