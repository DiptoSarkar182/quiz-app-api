class UserProfileInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    user_profile = User.get_profile_info(params[:user_id])

    if user_profile
      render json: user_profile, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
