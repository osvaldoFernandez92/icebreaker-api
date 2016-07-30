class UserJwt < SimpleDelegator
  def generate_token
    JsonWebToken.encode(id: id, email: email, token_validation_code: token_validation_code)
  end

  def valid_token?(token)
    Devise.secure_compare(token_validation_code, token['token_validation_code'])
  end

  private

  def initialize(user)
    super(user)
  end
end
