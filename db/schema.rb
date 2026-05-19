# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_19_000001) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "forum_posts", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "forum_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["forum_id"], name: "index_forum_posts_on_forum_id"
    t.index ["user_id"], name: "index_forum_posts_on_user_id"
  end

  create_table "forums", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_forums_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "receiver_id", null: false
    t.integer "sender_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_friendships_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_friendships_on_sender_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.integer "receiver_id", null: false
    t.integer "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_messages_on_sender_id_and_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "profile_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_profile_links_on_user_id"
  end

  create_table "travel_stories", force: :cascade do |t|
    t.string "client_name"
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location"
    t.boolean "published", default: false, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.date "visited_at"
    t.index ["user_id"], name: "index_travel_stories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.text "bio"
    t.string "city"
    t.string "confirmation_token"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "email_confirmed", default: false, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "name", null: false
    t.boolean "otp_enabled", default: false, null: false
    t.string "otp_secret"
    t.string "password_digest", null: false
    t.string "profession"
    t.string "provider"
    t.boolean "published", default: false, null: false
    t.string "role", default: "nomad", null: false
    t.text "specialties"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.string "webauthn_id", null: false
    t.string "whatsapp"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["webauthn_id"], name: "index_users_on_webauthn_id", unique: true
  end

  create_table "webauthn_credentials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "nickname", default: "Passkey", null: false
    t.string "public_key", null: false
    t.integer "sign_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["external_id"], name: "index_webauthn_credentials_on_external_id", unique: true
    t.index ["user_id"], name: "index_webauthn_credentials_on_user_id"
  end

  create_table "work_photos", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_work_photos_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "forum_posts", "forums"
  add_foreign_key "forum_posts", "users"
  add_foreign_key "forums", "users"
  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "friendships", "users", column: "sender_id"
  add_foreign_key "profile_links", "users"
  add_foreign_key "travel_stories", "users"
  add_foreign_key "webauthn_credentials", "users"
  add_foreign_key "work_photos", "users"
end
