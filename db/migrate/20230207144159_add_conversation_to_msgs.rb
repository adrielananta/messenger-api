class AddConversationToMsgs < ActiveRecord::Migration[6.1]
  def change
    add_reference :msgs, :conversation, null: false, foreign_key: true
  end
end
