class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.integer  :sender_id,   null: false
      t.integer  :receiver_id, null: false
      t.text     :body,        null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    add_index :messages, [:sender_id, :receiver_id]
  end
end
