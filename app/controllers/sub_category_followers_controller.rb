class SubCategoryFollowersController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def follow
    sub_category = SubCategory.find_by(id: params[:sub_category_id])

    if sub_category.nil?
      return render json: { message: "Subcategory not found" }, status: :not_found
    end

    if current_user.sub_categories.exists?(sub_category.id)
      return render json: { message: "You are already following this subcategory" }, status: :unprocessable_entity
    end

    sub_category_follower = current_user.sub_category_followers.new(sub_category: sub_category)

    if sub_category_follower.save
      sub_category.increment!(:total_follower)

      render json: { message: "Successfully followed the subcategory", sub_category: sub_category }, status: :ok
    else
      render json: { message: "Failed to follow the subcategory", errors: sub_category_follower.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def unfollow
    sub_category = SubCategory.find_by(id: params[:sub_category_id])

    if sub_category.nil?
      return render json: { message: "Subcategory not found" }, status: :not_found
    end

    # Find the sub_category_follower record
    sub_category_follower = current_user.sub_category_followers.find_by(sub_category: sub_category)

    if sub_category_follower.nil?
      return render json: { message: "You are not following this subcategory" }, status: :unprocessable_entity
    end

    # Destroy the follow record and decrement the total_follower count
    if sub_category_follower.destroy
      sub_category.decrement!(:total_follower)
      render json: { message: "Successfully unfollowed the subcategory", sub_category: sub_category }, status: :ok
    else
      render json: { message: "Failed to unfollow the subcategory", errors: sub_category_follower.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
