class Msg < ApplicationRecord
    belongs_to :user
    belongs_to :conversation

    validates_presence_of :message, :user_id
end
