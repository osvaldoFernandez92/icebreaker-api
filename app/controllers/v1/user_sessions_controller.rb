module V1
  class UserSessionsController < ApiController
     skip_before_action :current_user, :authenticate_request

    def login
      if !valid_user?
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      else
        access_token = user.generate_access_token
        render status: :created, json: user, serializer: UserSerializer, root: false, with_token: access_token
      end
    end

    # DELETE /v1/logout
    def logout
      render status: :no_content, nothing: true
    end

    # DELETE /v1/logout_from_all_devices
    def logout_from_all_devices
      current_user.update_attributes(token_validation_code: JsonWebToken.new_token_validation_code)
      render status: :no_content, nothing: true
    end

    private


      def valid_user?
        user.present? && user.valid_password?(authenticate_params[:password])
      end

      def user
        @user ||= User.find_by(email: authenticate_params[:email])
      end

      def authenticate_params
        params.require(:email)
        params.require(:password)
        params.permit(:email, :password)
      end


    def password_params
      params.require(:email)
      params.require(:password)
      params.require(:password_confirmation)
      params.require(:identifier)
      params.permit(
        email: Parameters.string,
        password: Parameters.string,
        password_confirmation: Parameters.string,
        identifier: Parameters.string
      )
    end

    def can_login?(user)
      user.present? && user.valid_password?(login_params[:password])
    end
  end
end
