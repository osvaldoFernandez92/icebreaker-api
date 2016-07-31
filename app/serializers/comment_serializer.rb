class CommentSerializer < ActiveModel::Serializer
  attributes :content, :user
end
