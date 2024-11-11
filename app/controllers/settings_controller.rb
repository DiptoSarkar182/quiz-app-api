class SettingsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_token_expiration

  def index
    # Fetch the current user's settings
    @settings = current_user.setting

    if @settings
      render json: @settings, status: :ok
    else
      render json: { message: "Settings not found" }, status: :not_found
    end
  end

  def update_settings
    @settings = current_user.setting

    if @settings.update(settings_params)
      render json: { message: "Settings Updated" }, status: :ok
    else
      render json: { message: "Failed to update settings", errors: @settings.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:settings).permit(:daily_update, :new_topic, :new_tournament)
  end
end
