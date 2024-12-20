class SubCategoriesController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :show_sub_category, :top_sub_categories ]
  before_action :authenticate_admin!, only: [ :create, :update_sub_category, :delete_sub_category ]
  before_action :check_token_expiration

  def index
    result = SubCategory.sub_categories_for_category(params[:category_id])

    if result[:status] == :ok
      render json: result[:data], status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def create
    result = SubCategory.create_sub_category(sub_category_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :created
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def show_sub_category
    result = SubCategory.show_sub_category(params[:sub_category_id])
    if result[:status] == :ok
      render json: result[:data], status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def update_sub_category
    result = SubCategory.update_sub_category(update_sub_category_params)

    if result[:status] == :ok
      render json: { message: result[:message], data: result[:data] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def delete_sub_category
    result = SubCategory.delete_sub_category(params[:sub_category_id])
    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message] }, status: result[:status]
    end
  end

  def top_sub_categories
    result = SubCategory.top_sub_categories_list

    if result.any?
      render json: result, status: :ok
    else
      render json: { message: "No top sub category" }, status: :ok
    end
  end

  private
  def sub_category_params
    params.require(:sub_category).permit(:category_id, :title)
  end

  def update_sub_category_params
    params.require(:sub_category).permit(:sub_category_id, :category_id, :title)
  end
end
