require 'json_web_token'

class JsonWebTokenStrategy < Devise::Strategies::Base
  def valid?
    request.headers[:AUTHORIZATION].present?
  end

  def authenticate!
    byebug
    json = claims
    unless json.blank?
      user = User.find_by_id(json['id'])
      return success! user if user.present? && UserJwt.new(user).valid_token?(json)
    end
    fail!
  end

  def store?
    true
  end

  private

  def claims
    auth_header = request.headers[:AUTHORIZATION] and
      JsonWebToken.decode(auth_header)
  rescue
    nil
  end
end
