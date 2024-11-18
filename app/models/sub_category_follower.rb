class SubCategoryFollower < ApplicationRecord

  belongs_to :user
  belongs_to :sub_category

  def self.follow_sub_category(user, sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)

    return { message: "Subcategory not found", status: :not_found } if sub_category.nil?

    if user.sub_categories.exists?(sub_category.id)
      return { message: "You are already following this subcategory", status: :unprocessable_entity }
    end

    sub_category_follower = user.sub_category_followers.new(sub_category: sub_category)

    if sub_category_follower.save
      sub_category.increment!(:total_follower)
      { status: :ok, message: "Successfully followed the subcategory", sub_category: sub_category }
    else
      { message: "Failed to follow the subcategory", errors: sub_category_follower.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def self.unfollow_sub_category(user, sub_category_id)
    sub_category = SubCategory.find_by(id: sub_category_id)

    return { message: "Subcategory not found", status: :not_found } if sub_category.nil?

    sub_category_follower = user.sub_category_followers.find_by(sub_category: sub_category)

    return { message: "You are not following this subcategory", status: :unprocessable_entity } if sub_category_follower.nil?

    if sub_category_follower.destroy
      sub_category.decrement!(:total_follower)
      { status: :ok, message: "Successfully unfollowed the subcategory", sub_category: sub_category }
    else
      { message: "Failed to unfollow the subcategory", errors: sub_category_follower.errors.full_messages, status: :unprocessable_entity }
    end
  end
end
