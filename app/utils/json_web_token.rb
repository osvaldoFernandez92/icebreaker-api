require 'jwt'

class JsonWebToken
  VALIDATION_CODE_LENGTH ||= 64
  TOKEN_EXPIRATION ||= 24.hours

  class << self
    def encode(payload, expiration = TOKEN_EXPIRATION.from_now)
      payload['exp'] = expiration.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base).first
    end

    def new_token_validation_code
      SecureRandom.base64(VALIDATION_CODE_LENGTH)
    end
  end
end
