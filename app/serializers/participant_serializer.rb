class ParticipantSerializer < ActiveModel::Serializer
  has_one :user, serializer: UserSerializer
end
