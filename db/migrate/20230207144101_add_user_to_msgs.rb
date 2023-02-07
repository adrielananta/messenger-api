class AddUserToMsgs < ActiveRecord::Migration[6.1]
  def change
    add_reference :msgs, :user, null: false, foreign_key: true
  end
end
