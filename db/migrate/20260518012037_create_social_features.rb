class CreateSocialFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :friendships do |t|
      t.references :sender,   null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
    add_index :friendships, [:sender_id, :receiver_id], unique: true

    create_table :forums do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.timestamps
    end

    create_table :forum_posts do |t|
      t.references :forum, null: false, foreign_key: true
      t.references :user,  null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end

    create_table :profile_links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :label, null: false
      t.string :url,   null: false
      t.timestamps
    end

    create_table :work_photos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :caption
      t.timestamps
    end
  end
end
