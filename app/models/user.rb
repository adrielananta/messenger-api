class User < ApplicationRecord
  # encrypt password
  has_secure_password
  has_and_belongs_to_many :conversations
  has_many :msgs
end
