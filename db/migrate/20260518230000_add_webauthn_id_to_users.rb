class AddWebauthnIdToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :webauthn_id, :string

    User.find_each do |user|
      user.update_column(:webauthn_id, SecureRandom.urlsafe_base64(32))
    end

    change_column_null :users, :webauthn_id, false
    add_index :users, :webauthn_id, unique: true
  end

  def down
    remove_column :users, :webauthn_id
  end
end
