class QuizChallenge < ApplicationRecord


  def self.create_quiz_challenge(params)
    subcategory_ids = params.delete(:subcategory_ids)

    if subcategory_ids.blank?
      return { status: :unprocessable_entity, message: "Subcategory IDs cannot be blank" }
    end

    existing_subcategories = SubCategory.where(id: subcategory_ids).pluck(:id)

    missing_subcategories = subcategory_ids - existing_subcategories

    if missing_subcategories.any?
      return { status: :unprocessable_entity, message: "The following subcategories do not exist: #{missing_subcategories.join(', ')}" }
    end

    quiz_challenge = QuizChallenge.new(params)
    quiz_challenge.sub_category_ids = subcategory_ids

    if quiz_challenge.save
      { status: :ok, message: "Quiz Challenge created successfully", data: quiz_challenge }
    else
      { status: :unprocessable_entity, message: quiz_challenge.errors.full_messages.to_sentence }
    end
  end

  def self.update_quiz_challenge(params)
    subcategory_ids = params.delete(:subcategory_ids)
    quiz_challenge_id = params.delete(:quiz_challenge_id)

    quiz_challenge = QuizChallenge.find_by(id: quiz_challenge_id)
    return { status: :not_found, message: "Quiz Challenge not found" } unless quiz_challenge

    if subcategory_ids.present?
      existing_subcategories = SubCategory.where(id: subcategory_ids).pluck(:id)
      missing_subcategories = subcategory_ids - existing_subcategories

      if missing_subcategories.any?
        return { status: :unprocessable_entity, message: "The following subcategories do not exist: #{missing_subcategories.join(', ')}" }
      end
    end

    quiz_challenge.sub_category_ids = subcategory_ids if subcategory_ids.present?

    if quiz_challenge.update(params)
      { status: :ok, message: "Quiz Challenge updated successfully", data: quiz_challenge }
    else
      { status: :unprocessable_entity, message: quiz_challenge.errors.full_messages.to_sentence }
    end
  end

  def self.delete_quiz_challenge(quiz_challenge_id)
    quiz_challenge = QuizChallenge.find_by(id: quiz_challenge_id)
    return { status: :not_found, message: "Quiz Challenge not found" } unless quiz_challenge

    if quiz_challenge.destroy
      { status: :ok, message: "Quiz Challenge deleted successfully" }
    else
      { status: :unprocessable_entity, message: quiz_challenge.errors.full_messages.to_sentence }
    end
  end

end
