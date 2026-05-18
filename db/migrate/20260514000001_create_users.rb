class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :country, null: false
      t.string :profession, null: false
      t.text :bio
      t.string :whatsapp
      t.boolean :published, null: false, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
