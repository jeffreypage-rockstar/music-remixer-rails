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

ActiveRecord::Schema.define(version: 20151110082642) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.string   "provider",      limit: 255, null: false
    t.string   "uid",           limit: 255, null: false
    t.string   "token",         limit: 255
    t.string   "refresh_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], name: "index_authentications_on_provider", using: :btree

  create_table "beta_artists", force: :cascade do |t|
    t.string   "name",        limit: 255,                 null: false
    t.string   "email",       limit: 255,                 null: false
    t.string   "artist_name", limit: 255,                 null: false
    t.string   "invite_code", limit: 255,                 null: false
    t.string   "artist_url",  limit: 255
    t.boolean  "is_active",               default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "beta_users", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "email",       limit: 255, null: false
    t.string   "message",     limit: 255
    t.string   "invite_code", limit: 255, null: false
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "beta_users", ["user_id"], name: "index_beta_users_on_user_id", using: :btree

  create_table "clip_types", force: :cascade do |t|
    t.integer  "song_id",    limit: 4
    t.string   "name",       limit: 255
    t.integer  "row",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "clips", force: :cascade do |t|
    t.integer  "song_id",      limit: 4
    t.string   "name",         limit: 255
    t.string   "row",          limit: 255
    t.string   "column",       limit: 255
    t.float    "duration",     limit: 24
    t.boolean  "state",                      default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "part_id",      limit: 4
    t.text     "file",         limit: 65535
    t.boolean  "state2",                     default: false
    t.boolean  "state3",                     default: false
    t.boolean  "user_content",               default: false
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "song_id",    limit: 4
    t.string   "name",       limit: 255
    t.float    "duration",   limit: 24
    t.string   "column",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "remixes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "song_id",    limit: 4
    t.string   "name",       limit: 255
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.float    "duration",   limit: 24
    t.text     "zipfile",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "mixaudio",   limit: 65535
    t.text     "mixaudio2",  limit: 65535
    t.text     "mixaudio3",  limit: 65535
    t.integer  "user_id",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255,                 null: false
    t.string   "username",                 limit: 255,                 null: false
    t.string   "name",                     limit: 255
    t.string   "encrypted_password",       limit: 128,                 null: false
    t.string   "confirmation_token",       limit: 128
    t.string   "remember_token",           limit: 128,                 null: false
    t.boolean  "is_admin",                             default: false
    t.boolean  "is_artist_admin",                      default: false
    t.string   "profile_image",            limit: 255
    t.string   "profile_background_image", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
