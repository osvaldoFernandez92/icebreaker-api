class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  validates :content, presence: true
end
