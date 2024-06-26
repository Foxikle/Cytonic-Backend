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

ActiveRecord::Schema[7.1].define(version: 2024_05_25_205650) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "banners", force: :cascade do |t|
    t.string "body"
    t.string "title"
    t.string "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_reports", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "reason", default: ""
    t.text "history"
    t.string "reporter_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_reports", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "user_id", null: false
    t.datetime "resolved_at"
    t.boolean "resolved", default: false, null: false
    t.text "action"
    t.bigint "resolving_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reason", default: "UNKOWN", null: false
    t.index ["comment_id"], name: "index_comment_reports_on_comment_id"
    t.index ["resolving_user_id"], name: "index_comment_reports_on_resolving_user_id"
    t.index ["user_id"], name: "index_comment_reports_on_user_id"
  end

  create_table "comment_versions", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "user_id", null: false
    t.text "body"
    t.datetime "edited_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_versions_on_comment_id"
    t.index ["user_id"], name: "index_comment_versions_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "thread_id", null: false
    t.text "body"
    t.boolean "edited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deleted_by"
    t.datetime "deleted_at"
    t.boolean "deleted", default: false
    t.index ["thread_id"], name: "index_comments_on_thread_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "name", default: ""
  end

  create_table "thread_reports", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.bigint "user_id", null: false
    t.datetime "resolved_at"
    t.boolean "resolved", default: false, null: false
    t.text "action"
    t.text "reason"
    t.bigint "resolving_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resolving_user_id"], name: "index_thread_reports_on_resolving_user_id"
    t.index ["thread_id"], name: "index_thread_reports_on_thread_id"
    t.index ["user_id"], name: "index_thread_reports_on_user_id"
  end

  create_table "thread_versions", force: :cascade do |t|
    t.bigint "thread_id", null: false
    t.bigint "user_id", null: false
    t.text "body"
    t.datetime "edited_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thread_id"], name: "index_thread_versions_on_thread_id"
    t.index ["user_id"], name: "index_thread_versions_on_user_id"
  end

  create_table "threads", force: :cascade do |t|
    t.string "title", null: false
    t.string "category", null: false
    t.string "topic", null: false
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.boolean "private", default: false
    t.boolean "deleted", default: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "locked_at"
    t.boolean "locked"
    t.boolean "edited"
    t.datetime "edited_at"
    t.index ["category"], name: "index_threads_on_category"
    t.index ["deleted_at"], name: "index_threads_on_deleted_at"
    t.index ["title"], name: "index_threads_on_title"
    t.index ["topic"], name: "index_threads_on_topic"
    t.index ["user_id"], name: "index_threads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.string "role", default: "user"
    t.boolean "linked"
    t.string "uuid"
    t.string "avatar_url"
    t.boolean "terminated", default: false
    t.datetime "termination_date"
    t.text "termination_reason"
    t.boolean "muted", default: false
    t.datetime "muted_at"
    t.datetime "muted_until"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comment_reports", "users"
  add_foreign_key "comment_reports", "users", column: "resolving_user_id"
  add_foreign_key "comment_versions", "comments"
  add_foreign_key "comment_versions", "users"
  add_foreign_key "comments", "threads"
  add_foreign_key "comments", "users"
  add_foreign_key "thread_reports", "threads"
  add_foreign_key "thread_reports", "users"
  add_foreign_key "thread_reports", "users", column: "resolving_user_id"
  add_foreign_key "thread_versions", "threads"
  add_foreign_key "thread_versions", "users"
  add_foreign_key "threads", "users"
end
