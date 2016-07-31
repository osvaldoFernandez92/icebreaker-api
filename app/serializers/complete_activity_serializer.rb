class CompleteActivitySerializer < ActiveModel::Serializer
  attributes(*Activity.attribute_names.map(&:to_sym))
  has_many :participants, serializer: ParticipantSerializer
  has_many :invited_users, serializer: InvitedUserSerializer
  has_many :comments, serializer: CommentSerializer
end
