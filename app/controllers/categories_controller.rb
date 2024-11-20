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

  def show_category
    result = Category.show_category(params[:category_id])
    if result[:status] == :ok
      render json: result[:data], status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def update_category
    result = Category.update_category(update_category_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def delete_category
    result = Category.delete_category(params[:category_id])
    if result[:status] == :ok
      render json: { message: result[:message] }, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  private
  def category_params
    params.require(:category).permit(:title)
  end

  def update_category_params
    params.require(:category).permit(:category_id, :title)
  end

end
