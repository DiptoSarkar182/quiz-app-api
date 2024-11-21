class Admins::ConfirmationsController < ApplicationController
  OTP_EXPIRATION_TIME = 5.minutes.ago

  def validate_otp
    admin = Admin.find_by_confirmation_token(params[:otp])

    if admin && admin.confirmation_sent_at >= OTP_EXPIRATION_TIME
      admin.confirm
      admin.update(confirmation_token: nil)
      render json: { message: "Email confirmed successfully!" }, status: :ok
    else
      render json: { error: "Invalid or expired OTP. Please try again." }, status: :unprocessable_entity
      admin&.update(confirmation_token: nil)
    end
  end

  def resend_otp
    admin = Admin.find_by(email: params[:email])
    if admin
      admin.send_confirmation_instructions
      render json: { message: "OTP resent successfully!" }, status: :ok
    else
      render json: { error: "Admin not found" }, status: :not_found
    end
  end
end
