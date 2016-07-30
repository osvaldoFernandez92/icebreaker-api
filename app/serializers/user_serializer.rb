class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :avatar_url, :interests, :description

  def attributes
    data = super
    data[:session_token] = self.serialization_options[:with_token] if self.serialization_options.present?
    data
  end
end
