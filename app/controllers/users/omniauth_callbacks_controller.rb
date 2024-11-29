class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user

      @token = request.env['warden-jwt_auth.token']

      user_data = UserSerializer.new(@user, { view: :private_info }).serializable_hash[:data][:attributes]

      render json: {
        status: {
          code: 200,
          message: 'Logged in successfully.',
          token: @token,
          data: { user: user_data }
        }
      }, status: :ok
    else
      render json: { errors: @user.errors.full_messages.join("\n") }, status: :bad_request
    end
  end
end
