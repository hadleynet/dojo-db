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

ActiveRecord::Schema.define(version: 20170129155200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.date     "date"
    t.integer  "person_id"
    t.integer  "style_id"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "session_id"
  end

  add_index "attendances", ["date"], name: "index_attendances_on_date", using: :btree

  create_table "awards", force: :cascade do |t|
    t.date     "date"
    t.integer  "person_id"
    t.integer  "rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "awards", ["date"], name: "index_awards_on_date", using: :btree
  add_index "awards", ["person_id"], name: "index_awards_on_person_id", using: :btree

  create_table "colors", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "forename"
    t.string   "surname"
    t.date     "birthdate"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "belt_size"
  end

  add_index "people", ["active"], name: "index_people_on_active", using: :btree

  create_table "ranks", force: :cascade do |t|
    t.integer  "style_id"
    t.string   "name"
    t.string   "translation"
    t.integer  "order"
    t.boolean  "active"
    t.integer  "class_delta"
    t.integer  "next_rank_test_id"
    t.integer  "belt_color_id"
    t.integer  "stripe_color_id"
    t.integer  "stripe_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.integer  "day_of_week"
    t.integer  "style_id"
    t.integer  "hour"
    t.integer  "minute"
    t.boolean  "am"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "active"
  end

  create_table "styles", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "active"
    t.integer  "order"
  end

  create_table "tests", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
