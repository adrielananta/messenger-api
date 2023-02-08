class User < ApplicationRecord
  # encrypt password
  has_secure_password
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :msgs
end
