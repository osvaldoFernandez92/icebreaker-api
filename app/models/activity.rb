class Activity < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  has_many :comments
  has_many :invited_users
  has_many :participants
end
