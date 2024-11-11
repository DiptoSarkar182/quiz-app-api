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
end
