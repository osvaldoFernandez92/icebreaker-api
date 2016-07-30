class ApiController < ActionController::Base
  class NotAuthenticatedError < StandardError; end
  class AuthenticationTimeoutError < StandardError; end

  protect_from_forgery with: :null_session

  before_action :current_user, :authenticate_request, except: :health

  rescue_from 'NotAuthenticatedError' do
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  rescue_from 'AuthenticationTimeoutError' do
    render json: { error: 'Auth token is expired' }, status: 419
  end

  rescue_from ActionController::ParameterMissing, with: :render_nothing_bad_req

  rescue_from ActiveRecord::RecordNotFound, with: :render_nothing_bad_req

  def health
    head :ok
  end

  def default_serializer_options
    { root: false }
  end

  private

  def current_user
    return nil unless decoded_auth_token.present?
    @current_user ||= User.find_by_id(decoded_auth_token[:user_id])
  end

  def authenticate_request
    raise AuthenticationTimeoutError if auth_token_expired?
    raise NotAuthenticatedError unless current_user.present?
  end

  def decoded_auth_token
    @decoded_auth_token ||= TokenManager::AuthToken.decode(http_auth_header_content)
  end

  def auth_token_expired?
    decoded_auth_token && decoded_auth_token.expired?
  end

  def http_auth_header_content
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end
  end

  def render_nothing_bad_req
    render nothing: true, status: :bad_request
  end

  def render_errors(errors)
    render json: { errors: errors }, status: :bad_request
  end
end
