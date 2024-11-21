class Users::PasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:user][:email])
    if user
      user.send_reset_password_otp
      render json: { message: "Password reset OTP sent successfully!" }, status: :ok
    else
      render json: { error: "Email not found or invalid. Please try again." }, status: :unprocessable_entity
    end
  end

  def verify_otp
    user = User.find_by(email: params[:user][:email])
    if user && user.verify_reset_password_otp(params[:user][:otp])
      render json: { message: "OTP verified successfully!" }, status: :ok
    else
      render json: { error: "Invalid or expired OTP. Please try again." }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find_by(email: params[:user][:email])
    if user && user.verify_reset_password_otp(params[:user][:otp])
      user.password = params[:user][:password]
      user.reset_password_token = nil
      if user.save
        render json: { message: "Password has been successfully reset!" }, status: :ok
      else
        render json: { error: user.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or expired OTP. Please try again." }, status: :unprocessable_entity
    end
  end
end
