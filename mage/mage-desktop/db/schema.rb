# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140521134619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_devices_pins", force: true do |t|
    t.string   "pin"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_tokens", force: true do |t|
    t.string   "token"
    t.integer  "api_authenticable_id"
    t.string   "api_authenticable_type"
    t.boolean  "expired",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backlog_item_assignments", force: true do |t|
    t.integer  "backlog_id"
    t.integer  "backlog_item_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backlog_item_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "backlog_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "backlog_item_taggings", ["backlog_item_id"], name: "index_backlog_item_taggings_on_backlog_item_id", using: :btree
  add_index "backlog_item_taggings", ["tag_id"], name: "index_backlog_item_taggings_on_tag_id", using: :btree

  create_table "backlog_items", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backlogs", force: true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.string   "name",                           null: false
    t.integer  "device_type",                    null: false
    t.integer  "sign_in_count",      default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["name"], name: "index_devices_on_name", using: :btree

  create_table "estimate_options", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
  end

  create_table "meeting_participations", force: true do |t|
    t.integer "meeting_id"
    t.integer "meeting_participant_id"
    t.string  "meeting_participant_type"
  end

  create_table "meetings", force: true do |t|
    t.string   "name"
    t.integer  "meeting_type"
    t.integer  "initiator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",       default: true
  end

  create_table "poker_sessions", force: true do |t|
    t.integer  "meeting_id"
    t.integer  "backlog_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "rounds",             default: 1
    t.integer  "estimate_option_id"
  end

  add_index "poker_sessions", ["backlog_item_id"], name: "index_poker_sessions_on_backlog_item_id", using: :btree
  add_index "poker_sessions", ["estimate_option_id"], name: "index_poker_sessions_on_estimate_option_id", using: :btree
  add_index "poker_sessions", ["meeting_id"], name: "index_poker_sessions_on_meeting_id", using: :btree

  create_table "poker_votes", force: true do |t|
    t.integer  "poker_session_id"
    t.integer  "user_id"
    t.integer  "estimate_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round"
  end

  add_index "poker_votes", ["estimate_option_id"], name: "index_poker_votes_on_estimate_option_id", using: :btree
  add_index "poker_votes", ["poker_session_id"], name: "index_poker_votes_on_poker_session_id", using: :btree
  add_index "poker_votes", ["user_id"], name: "index_poker_votes_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end