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

ActiveRecord::Schema.define(version: 20160204230127) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",      null: false
    t.string   "uid",           null: false
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], name: "index_authentications_on_provider", using: :btree
  add_index "authentications", ["uid"], name: "index_authentications_on_uid", using: :btree

  create_table "beta_artists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",        null: false
    t.string   "email",       null: false
    t.string   "artist_name", null: false
    t.string   "artist_url",  null: false
    t.text     "message"
    t.string   "invite_code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "beta_artists", ["email"], name: "index_beta_artists_on_email", unique: true
  add_index "beta_artists", ["user_id"], name: "index_beta_artists_on_user_id"

  create_table "beta_users", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "name",        limit: 255, null: false
    t.string   "email",       limit: 255, null: false
    t.string   "message",     limit: 255
    t.string   "invite_code", limit: 255, null: false
    t.integer  "age",         limit: 4
    t.integer  "phone_type",  limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "beta_users", ["user_id"], name: "index_beta_users_on_user_id"

  create_table "beta_users_music_backgrounds", force: :cascade do |t|
    t.integer "beta_user_id"
    t.integer "music_background_id"
  end

  add_index "beta_users_music_backgrounds", ["beta_user_id"], name: "index_beta_users_music_backgrounds_on_beta_user_id"
  add_index "beta_users_music_backgrounds", ["music_background_id"], name: "index_beta_users_music_backgrounds_on_music_background_id"

  create_table "clip_types", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name",       limit: 40
    t.integer  "row"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "clip_types", ["song_id"], name: "index_clip_types_on_song_id"

  create_table "clips", force: :cascade do |t|
    t.integer  "song_id",           limit: 4
    t.integer  "part_id",           limit: 4
    t.integer  "clip_type_id",      limit: 4
    t.string   "uuid",              limit: 24
    t.integer  "row",               limit: 4
    t.integer  "column",            limit: 4
    t.boolean  "state",                         default: false
    t.boolean  "state2",                        default: false
    t.boolean  "state3",                        default: false
    t.boolean  "allow_ugc",                     default: false
    t.float    "duration",          limit: 24
    t.string   "original_filename", limit: 255
    t.string   "file",              limit: 255
    t.string   "file_tmp",          limit: 255
    t.integer  "storing_status",    limit: 4,   default: 0
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "file_aac",          limit: 255
    t.string   "file_aac_tmp",      limit: 255
  end

  add_index "clips", ["part_id"], name: "index_clips_on_part_id", using: :btree
  add_index "clips", ["song_id"], name: "index_clips_on_song_id", using: :btree
  add_index "clips", ["uuid"], name: "index_clips_on_uuid", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables"
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes"

  create_table "mailkick_opt_outs", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "user_type"
    t.boolean  "active",     default: true, null: false
    t.string   "reason"
    t.string   "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailkick_opt_outs", ["email"], name: "index_mailkick_opt_outs_on_email"
  add_index "mailkick_opt_outs", ["user_id", "user_type"], name: "index_mailkick_opt_outs_on_user_id_and_user_type"

  create_table "mentions", force: :cascade do |t|
    t.string   "mentioner_type"
    t.integer  "mentioner_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables"
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions"

  create_table "music_backgrounds", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "name",       limit: 40
    t.integer  "column"
    t.float    "duration"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "parts", ["song_id"], name: "index_parts_on_song_id"

  create_table "referrals", force: :cascade do |t|
    t.string   "email",        null: false
    t.string   "name"
    t.string   "invite_code",  null: false
    t.string   "message"
    t.integer  "referring_id"
    t.integer  "referred_id"
    t.datetime "clicked_at"
    t.datetime "signed_up_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "referrals", ["referred_id"], name: "index_referrals_on_referred_id"
  add_index "referrals", ["referring_id"], name: "index_referrals_on_referring_id"

  create_table "remixes", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "song_id",         limit: 4
    t.string   "uuid",            limit: 24
    t.string   "name",            limit: 255
    t.integer  "status",          limit: 4,     default: 0
    t.text     "config",          limit: 65535
    t.text     "automation",      limit: 65535
    t.string   "audio",           limit: 255
    t.string   "audio_tmp",       limit: 255
    t.integer  "downloads_count", limit: 4,     default: 0
    t.integer  "plays_count",     limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remixes", ["uuid"], name: "index_remixes_on_uuid", unique: true, using: :btree

  create_table "songs", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.string   "name",               limit: 255,             null: false
    t.integer  "status",             limit: 4,   default: 0
    t.float    "duration",           limit: 24
    t.integer  "bpm",                limit: 4
    t.string   "zipfile",            limit: 255
    t.string   "zipfile_tmp",        limit: 255
    t.string   "mixaudio",           limit: 255
    t.string   "mixaudio_tmp",       limit: 255
    t.string   "waveform",           limit: 255
    t.string   "waveform_data",      limit: 255
    t.string   "image",              limit: 255
    t.string   "uuid",               limit: 24
    t.integer  "downloads_count",    limit: 4,   default: 0
    t.integer  "plays_count",        limit: 4,   default: 0
    t.integer  "remixes_count",      limit: 4,   default: 0
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "mixaudio_mix2",      limit: 255
    t.string   "mixaudio_mix2_tmp",  limit: 255
    t.string   "mixaudio_mix3",      limit: 255
    t.string   "mixaudio_mix3_tmp",  limit: 255
    t.string   "waveform_mix2",      limit: 255
    t.string   "waveform_data_mix2", limit: 255
    t.string   "waveform_mix3",      limit: 255
    t.string   "waveform_data_mix3", limit: 255
  end

  add_index "songs", ["user_id"], name: "index_songs_on_user_id", using: :btree
  add_index "songs", ["uuid"], name: "index_songs_on_uuid", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "uuid",                     limit: 24
    t.string   "email",                    limit: 255,                   null: false
    t.string   "username",                 limit: 50,                    null: false
    t.string   "name",                     limit: 80
    t.string   "encrypted_password",       limit: 128,                   null: false
    t.string   "remember_token",           limit: 128,                   null: false
    t.integer  "status",                   limit: 4,     default: 0
    t.boolean  "is_admin",                               default: false
    t.boolean  "is_artist_admin",                        default: false
    t.string   "profile_image",            limit: 255
    t.string   "profile_background_image", limit: 255
    t.string   "location",                 limit: 80
    t.text     "bio",                      limit: 65535
    t.string   "facebook",                 limit: 255
    t.string   "twitter",                  limit: 255
    t.string   "soundcloud",               limit: 255
    t.string   "instagram",                limit: 255
    t.integer  "followees_count",          limit: 4,     default: 0
    t.integer  "followers_count",          limit: 4,     default: 0
    t.integer  "songs_count",              limit: 4,     default: 0
    t.integer  "remixes_count",            limit: 4,     default: 0
    t.string   "confirmation_token",       limit: 128
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

end
