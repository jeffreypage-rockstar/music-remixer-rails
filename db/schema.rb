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

ActiveRecord::Schema.define(version: 20151023041849) do

  create_table "_songs_old_20150921", force: :cascade do |t|
    t.string   "name"
    t.float    "duration"
    t.text     "zipfile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "mixed_file"
    t.text     "mixaudio"
    t.text     "mixaudio2"
    t.text     "mixaudio3"
  end

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
    t.boolean  "state",        default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "part_id"
    t.text     "file"
    t.boolean  "state2",       default: false
    t.boolean  "state3",       default: false
    t.boolean  "user_content", default: false
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
    t.string   "name"
    t.float    "duration"
    t.text     "zipfile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "mixaudio"
    t.text     "mixaudio2"
    t.text     "mixaudio3"
  end

end
