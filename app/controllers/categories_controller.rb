class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @categories = Category.all
    render json: @categories
  end
end
