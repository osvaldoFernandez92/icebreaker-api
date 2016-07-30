class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :validatable
  has_many :comments
  has_many :participants
  has_many :invited_users

  def generate_access_token
    payload = { user_id: id }
    TokenManager::AuthToken.encode(payload)
  end

  enum gender: [:n_a, :female, :male]

end
