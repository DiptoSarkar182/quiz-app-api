class SettingsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    @settings = Setting.current_user_settings(current_user)

    if @settings
      render json: @settings, status: :ok
    else
      render json: { message: "Settings not found" }, status: :not_found
    end
  end

  def update_settings
    result = Setting.current_user_update_settings(current_user, settings_params)

    if result[:status] == :ok
      render json: { message: result[:message] }, status: :ok
    else
      render json: { message: result[:message], errors: result[:errors] }
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:daily_update, :new_topic, :new_tournament)
  end
end
