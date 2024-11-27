class ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :profile_picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :profile_picture])
  end

  private

  def check_token_expiration
    token = request.headers["Authorization"]&.split(" ")&.last
    if token.present?
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
      exp = decoded_token["exp"]
      if Time.at(exp) < Time.now
        render json: { error: "Token has expired" }, status: :unauthorized
      end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def authenticate_admin!
    authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    if token.present?
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
      scope = decoded_token["scp"]
      render json: { error: "Access denied" }, status: :forbidden unless scope == "admin"
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: "Invalid token" }, status: :unauthorized
  end
end
