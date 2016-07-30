class ActivitySerializer < ActiveModel::Serializer
  attributes(*Activity.attribute_names.map(&:to_sym))
  has_many :participants, serializer: ParticipantSerializer
  has_many :invited_users, serializer: InvitedUserSerializer
end
