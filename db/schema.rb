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

ActiveRecord::Schema.define(version: 20151125024800) do

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
    t.integer  "song_id",         limit: 4
    t.string   "name",            limit: 255
    t.string   "row",             limit: 255
    t.string   "column",          limit: 255
    t.float    "duration",        limit: 24
    t.boolean  "state",                         default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "part_id",         limit: 4
    t.text     "file",            limit: 65535
    t.boolean  "state2",                        default: false
    t.boolean  "state3",                        default: false
    t.boolean  "user_content",                  default: false
    t.string   "uuid",            limit: 255
    t.string   "file_tmp",        limit: 255
    t.boolean  "file_processing",               default: false, null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type",   limit: 255
    t.integer  "follower_id",     limit: 4
    t.string   "followable_type", limit: 255
    t.integer  "followable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type",    limit: 255
    t.integer  "liker_id",      limit: 4
    t.string   "likeable_type", limit: 255
    t.integer  "likeable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.string   "mentioner_type",   limit: 255
    t.integer  "mentioner_id",     limit: 4
    t.string   "mentionable_type", limit: 255
    t.integer  "mentionable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

  create_table "parts", force: :cascade do |t|
    t.integer  "song_id",    limit: 4
    t.string   "name",       limit: 255
    t.float    "duration",   limit: 24
    t.string   "column",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "remixes", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "song_id",         limit: 4
    t.string   "name",            limit: 255
    t.text     "config",          limit: 65535
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "downloads_count", limit: 4,     default: 0
    t.integer  "plays_count",     limit: 4,     default: 0
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name",                limit: 255,                   null: false
    t.float    "duration",            limit: 24
    t.text     "zipfile",             limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "mixaudio",            limit: 65535
    t.text     "mixaudio2",           limit: 65535
    t.text     "mixaudio3",           limit: 65535
    t.integer  "user_id",             limit: 4
    t.string   "image",               limit: 255
    t.integer  "status",              limit: 4,     default: 0
    t.string   "uuid",                limit: 255
    t.string   "zipfile_tmp",         limit: 255
    t.string   "mixaudio_tmp",        limit: 255
    t.boolean  "zipfile_processing",                default: false, null: false
    t.boolean  "mixaudio_processing",               default: false, null: false
    t.integer  "downloads_count",     limit: 4,     default: 0
    t.integer  "plays_count",         limit: 4,     default: 0
    t.integer  "remixes_count",       limit: 4,     default: 0
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255,                   null: false
    t.string   "username",                 limit: 255,                   null: false
    t.string   "name",                     limit: 255
    t.string   "encrypted_password",       limit: 128,                   null: false
    t.string   "confirmation_token",       limit: 128
    t.string   "remember_token",           limit: 128,                   null: false
    t.boolean  "is_admin",                               default: false
    t.boolean  "is_artist_admin",                        default: false
    t.string   "profile_image",            limit: 255
    t.string   "profile_background_image", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "followees_count",          limit: 4,     default: 0
    t.integer  "followers_count",          limit: 4,     default: 0
    t.integer  "songs_count",              limit: 4,     default: 0
    t.string   "location",                 limit: 128
    t.text     "bio",                      limit: 65535
    t.string   "facebook",                 limit: 255
    t.string   "twitter",                  limit: 255
    t.string   "soundcloud",               limit: 255
    t.string   "instagram",                limit: 255
    t.string   "uuid",                     limit: 255
    t.integer  "remixes_count",            limit: 4,     default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
