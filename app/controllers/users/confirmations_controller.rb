# app/controllers/users/confirmations_controller.rb

class Users::ConfirmationsController < ApplicationController
  OTP_EXPIRATION_TIME = 5.minutes.ago

  def validate_otp
    user = User.find_by_confirmation_token(params[:otp])

    if user && user.confirmation_sent_at >= OTP_EXPIRATION_TIME
      user.confirm
      user.update(confirmation_token: nil)
      render json: { message: 'Email confirmed successfully!' }, status: :ok
    else
      # Ensure `update` is not called if `user` is nil
      render json: { error: 'Invalid or expired OTP. Please try again.' }, status: :unprocessable_entity
      user&.update(confirmation_token: nil) # Use safe navigation (`&.`) to avoid calling `update` on `nil`
    end
  end

  def resend_otp
    user = User.find_by(email: params[:email])
    if user
      user.send_confirmation_instructions
      render json: { message: 'OTP resent successfully!' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end

