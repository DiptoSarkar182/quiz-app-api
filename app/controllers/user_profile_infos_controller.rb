class UserProfileInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    user = User.find_by(id: params[:user_id])

    if user
      profile_picture_url = if user.profile_picture.attached?
                              url_for(user.profile_picture)
                            else
                              "no profile picture"
                            end

      user_profile = {
        id: user.id,
        full_name: user.full_name,
        email: user.email,
        profile_picture_url: profile_picture_url
      }

      render json: user_profile, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
