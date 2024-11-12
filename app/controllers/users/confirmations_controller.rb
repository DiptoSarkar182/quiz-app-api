# app/controllers/users/confirmations_controller.rb
module Users
  class ConfirmationsController < ApplicationController
    OTP_EXPIRATION_TIME = 5.minutes.ago

    def validate_otp
      user = User.find_by_confirmation_token(params[:otp])

      if user && user.confirmation_sent_at >= OTP_EXPIRATION_TIME
        user.confirm
        user.update(confirmation_token: nil)
        render json: { message: 'Email confirmed successfully!' }, status: :ok
      else
        render json: { error: 'Invalid or expired OTP. Please try again.' }, status: :unprocessable_entity
      end
    end

    def resend_otp
      user = User.find_by(id: params[:user_id])
      if user
        user.send_confirmation_instructions
        render json: { message: 'OTP resent successfully!' }, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end
end
