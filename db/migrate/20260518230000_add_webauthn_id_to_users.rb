class AddWebauthnIdToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :webauthn_id, :string unless column_exists?(:users, :webauthn_id)

    # Raw SQL — never load application models in migrations
    select_all("SELECT id FROM users WHERE webauthn_id IS NULL").each do |row|
      execute("UPDATE users SET webauthn_id = '#{SecureRandom.urlsafe_base64(32)}' WHERE id = #{row['id'].to_i}")
    end

    change_column_null :users, :webauthn_id, false
    add_index :users, :webauthn_id, unique: true unless index_exists?(:users, :webauthn_id)
  end

  def down
    remove_column :users, :webauthn_id
  end
end
