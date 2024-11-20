class Setting < ApplicationRecord
  belongs_to :user

  def self.current_user_settings(user)
    user.setting
  end

  def self.current_user_update_settings(user, params)
    settings = user.setting
    if settings.update(params)
      { status: :ok, message: "Settings Updated" }
    else
      { success: false, message: "Failed to update settings", errors: settings.errors.full_messages }
    end
  end
end
