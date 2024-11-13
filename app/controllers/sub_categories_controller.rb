class SubCategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    category_id = params[:category_id]
    category = Category.find_by(id: category_id)

    if category
      sub_categories = category.sub_categories
      render json: sub_categories, status: :ok
    else
      render json: { error: "Category not found" }, status: :not_found
    end
  end

  def top_sub_categories
    @top_sub_categories = SubCategory.where("total_follower > 0").order(total_follower: :desc).limit(10)

    if @top_sub_categories.any?
      render json: @top_sub_categories, status: :ok
    else
      render json: { message: "No top sub category" }, status: :ok
    end
  end
end
