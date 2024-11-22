class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :authenticate_user!, only: [:update, :destroy]
  before_action :check_token_expiration, only: [:update, :destroy]

  def destroy
    if resource.destroy
      render json: {
        status: { code: 200, message: 'User account deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: { message: "User account couldn't be deleted. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def update
    if resource.update_with_password(resource_params)
      render json: {
        status: { code: 200, message: 'User information updated successfully.',
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }, status: :ok
    else
      render json: {
        status: { message: "User information couldn't be updated. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end



  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: { code: 200, message: 'Signed up successfully.',
                  token: @token,
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def resource_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :current_password, :profile_picture)
  end
end