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

  def create
    result = Category.create_category(category_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  private
  def category_params
    params.require(:category).permit(:title)
  end

end
