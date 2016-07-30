class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  def attributes
    data = super
    data[:session_token] = self.serialization_options[:with_token] if self.serialization_options.present?
    data
  end
end
