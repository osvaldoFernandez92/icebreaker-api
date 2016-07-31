class CommentSerializer < ActiveModel::Serializer
  attributes :content, :user_id
end
