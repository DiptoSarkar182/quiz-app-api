# app/controllers/admins/sessions_controller.rb
class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opt = {})
    @token = request.env['warden-jwt_auth.token']
    headers['Authorization'] = @token

    render json: {
      status: {
        code: 200, message: 'Admin logged in successfully.',
        token: @token,
        data: {
          admin: AdminSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                               Rails.application.credentials.devise_jwt_secret_key!).first

      current_admin = Admin.find(jwt_payload['sub'])
    end

    if current_admin
      render json: {
        status: 200,
        message: 'Admin logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session for admin."
      }, status: :unauthorized
    end
  end
end
