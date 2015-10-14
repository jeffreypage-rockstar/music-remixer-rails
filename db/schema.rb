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

ActiveRecord::Schema.define(version: 20151011200423) do

  create_table "artists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       null: false
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "artists", ["user_id"], name: "index_artists_on_user_id"

  create_table "beta_artists", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "email",                       null: false
    t.string   "artist_name",                 null: false
    t.string   "invite_code",                 null: false
    t.string   "artist_url"
    t.boolean  "is_active",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "beta_users", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "email",       null: false
    t.string   "message"
    t.string   "invite_code", null: false
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "beta_users", ["user_id"], name: "index_beta_users_on_user_id"

  create_table "clip_types", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name"
    t.integer  "row"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clips", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name"
    t.string   "row"
    t.string   "column"
    t.float    "duration"
    t.boolean  "state",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "part_id"
    t.text     "file"
    t.boolean  "state2",     default: false
    t.boolean  "state3",     default: false
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name"
    t.float    "duration"
    t.string   "column"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name",       null: false
    t.float    "duration"
    t.text     "zipfile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "mixaudio"
    t.text     "mixaudio2"
    t.text     "mixaudio3"
    t.integer  "artist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                            null: false
    t.string   "username",                                         null: false
    t.string   "name"
    t.string   "encrypted_password",   limit: 128,                 null: false
    t.string   "confirmation_token",   limit: 128
    t.string   "remember_token",       limit: 128,                 null: false
    t.boolean  "is_admin",                         default: false
    t.boolean  "is_artist_admin",                  default: false
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["username"], name: "index_users_on_username"

end
