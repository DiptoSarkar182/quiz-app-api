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

ActiveRecord::Schema[7.2].define(version: 2024_11_25_094820) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "challenge_type_enum", ["single_subject", "global"]

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

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["jti"], name: "index_admins_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_friends", force: :cascade do |t|
    t.bigint "challenger_id", null: false
    t.bigint "challengee_id", null: false
    t.bigint "sub_category_id", null: false
    t.integer "amount_of_betting_coin", default: 0, null: false
    t.enum "challenge_type", null: false, enum_type: "challenge_type_enum"
    t.integer "number_of_questions", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.index ["challengee_id"], name: "index_challenge_friends_on_challengee_id"
    t.index ["challenger_id"], name: "index_challenge_friends_on_challenger_id"
    t.index ["sub_category_id"], name: "index_challenge_friends_on_sub_category_id"
  end

  create_table "friend_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friend_lists_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friend_lists_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friend_lists_on_user_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_friend_requests_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_friend_requests_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_friend_requests_on_sender_id"
  end

  create_table "leaderboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_leaderboards_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "daily_update"
    t.boolean "new_topic"
    t.boolean "new_tournament"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_follower", default: 0
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "sub_category_followers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_category_id"], name: "index_sub_category_followers_on_sub_category_id"
    t.index ["user_id"], name: "index_sub_category_followers_on_user_id"
  end

  create_table "sub_category_leaderboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sub_category_id", null: false
    t.integer "sub_category_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_category_id"], name: "index_sub_category_leaderboards_on_sub_category_id"
    t.index ["user_id"], name: "index_sub_category_leaderboards_on_user_id"
  end

  create_table "sub_category_quizzes", force: :cascade do |t|
    t.bigint "sub_category_id", null: false
    t.string "quiz_question", default: "", null: false
    t.jsonb "quiz_options", default: []
    t.integer "correct_answer_index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_category_id"], name: "index_sub_category_quizzes_on_sub_category_id"
  end

  create_table "user_question_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sub_category_quiz_id", null: false
    t.boolean "is_correct_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_category_quiz_id"], name: "index_user_question_histories_on_sub_category_quiz_id"
    t.index ["user_id"], name: "index_user_question_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", default: "", null: false
    t.integer "level", default: 0, null: false
    t.integer "coins", default: 0, null: false
    t.integer "gems", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "challenge_friends", "sub_categories"
  add_foreign_key "challenge_friends", "users", column: "challengee_id"
  add_foreign_key "challenge_friends", "users", column: "challenger_id"
  add_foreign_key "friend_lists", "users", column: "friend_id", on_delete: :cascade
  add_foreign_key "friend_lists", "users", on_delete: :cascade
  add_foreign_key "friend_requests", "users", column: "receiver_id"
  add_foreign_key "friend_requests", "users", column: "sender_id"
  add_foreign_key "leaderboards", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "sub_category_followers", "sub_categories"
  add_foreign_key "sub_category_followers", "users"
  add_foreign_key "sub_category_leaderboards", "sub_categories"
  add_foreign_key "sub_category_leaderboards", "users"
  add_foreign_key "sub_category_quizzes", "sub_categories"
  add_foreign_key "user_question_histories", "sub_category_quizzes"
  add_foreign_key "user_question_histories", "users"
end
