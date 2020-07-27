# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_18_114824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", limit: 40, null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "card_last4", limit: 4
    t.integer "card_exp_month", limit: 2
    t.integer "card_exp_year"
    t.string "card_type"
    t.datetime "current_period_end"
    t.boolean "trialing", default: true, null: false
    t.boolean "past_due", default: false, null: false
    t.boolean "unpaid", default: false, null: false
    t.boolean "cancelled", default: false, null: false
    t.integer "active_users_count", default: 0, null: false
    t.uuid "plan_id"
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cancelled"], name: "index_accounts_on_cancelled"
    t.index ["current_period_end"], name: "index_accounts_on_current_period_end"
    t.index ["discarded_at"], name: "index_accounts_on_discarded_at"
    t.index ["name"], name: "index_accounts_on_name"
    t.index ["past_due"], name: "index_accounts_on_past_due"
    t.index ["plan_id"], name: "index_accounts_on_plan_id"
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
    t.index ["unpaid"], name: "index_accounts_on_unpaid"
  end

  create_table "accounts_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.uuid "account_id", null: false
    t.uuid "user_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "user_id"], name: "index_accounts_users_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_accounts_users_on_account_id"
    t.index ["discarded_at"], name: "index_accounts_users_on_discarded_at"
    t.index ["role"], name: "index_accounts_users_on_role"
    t.index ["user_id"], name: "index_accounts_users_on_user_id"
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "stripe_id"
    t.integer "amount"
    t.string "currency"
    t.string "number"
    t.datetime "paid_at"
    t.text "lines"
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_invoices_on_account_id"
    t.index ["stripe_id"], name: "index_invoices_on_stripe_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action"
    t.string "target_name_cached"
    t.json "target_path_params"
    t.boolean "read", default: false, null: false
    t.uuid "sender_id"
    t.uuid "recipient_id"
    t.string "notifiable_type"
    t.uuid "notifiable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", null: false
    t.string "currency", null: false
    t.string "interval", null: false
    t.string "stripe_id", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "super_admin", default: false, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invitations_count", default: 0, null: false
    t.uuid "invited_account_id"
    t.uuid "invited_by_id"
    t.datetime "discarded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider_type"
    t.string "provider_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_account_id"], name: "index_users_on_invited_account_id"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["provider_id", "provider_type"], name: "index_users_on_provider_id_and_provider_type", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "plans"
  add_foreign_key "accounts_users", "accounts"
  add_foreign_key "accounts_users", "users"
  add_foreign_key "invoices", "accounts"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "users", "accounts", column: "invited_account_id"
  add_foreign_key "users", "users", column: "invited_by_id"
end
