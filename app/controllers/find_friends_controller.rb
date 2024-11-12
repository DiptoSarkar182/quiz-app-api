class FindFriendsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration


  def index
    @q = User.ransack(full_name_or_email_cont: params[:query])
    @users = @q.result(distinct: true).select(:id, :full_name, :level)

    if @users.any?
      render json: @users.as_json(only: [:id, :full_name, :level])
    else
      render json: {  message: "No user found"  }, status: :not_found
    end
  end
end
