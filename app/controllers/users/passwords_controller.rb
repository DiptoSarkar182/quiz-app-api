class Users::PasswordsController < Devise::PasswordsController

  def create
    self.resource = resource_class.send_reset_password_instructions(params[:user])
    if successfully_sent?(resource)
      render json: { message: 'Password reset instructions sent successfully!' }, status: :ok
    else
      render json: { error: 'Email not found or invalid. Please try again.' }, status: :unprocessable_entity
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(params[:user])

    if resource.errors.empty?
      render json: { message: 'Password has been successfully reset!' }, status: :ok
    else
      render json: { error: resource.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end
end
