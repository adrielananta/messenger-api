class AddUnreadtoConversationUser < ActiveRecord::Migration[6.1]
  def change
    add_column :conversation_users, :unread, :bigint
  end
end
