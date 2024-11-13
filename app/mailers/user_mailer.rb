class UserMailer < ApplicationMailer

  def confirmation_instructions(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'Your OTP for email confirmation')
  end

end