class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @categories = Category.all_categories

    if @categories.any?
      render json: @categories, status: :ok
    else
      render json: {message: "Categories not found"}, status: 404
    end
  end
end
