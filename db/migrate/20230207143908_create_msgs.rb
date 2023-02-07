class CreateMsgs < ActiveRecord::Migration[6.1]
  def change
    create_table :msgs do |t|
      t.string :message

      t.timestamps
    end
  end
end
