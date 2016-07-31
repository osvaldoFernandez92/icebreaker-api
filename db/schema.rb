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

ActiveRecord::Schema.define(version: 20160731010806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.text     "title"
    t.integer  "interests",   default: [], array: true
    t.text     "description"
    t.text     "location"
    t.boolean  "completed"
    t.integer  "max_users"
    t.integer  "min_users"
    t.datetime "ends"
    t.string   "picture_url"
    t.integer  "owner_id"
    t.boolean  "challenge"
    t.boolean  "discount"
  end

  create_table "comments", force: :cascade do |t|
    t.text    "content"
    t.integer "user_id"
    t.integer "activity_id"
  end

  add_index "comments", ["activity_id"], name: "index_comments_on_activity_id", using: :btree

  create_table "invited_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                 default: "", null: false
    t.string   "encrypted_password",    default: "", null: false
    t.string   "token_validation_code", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.integer  "age"
    t.text     "description"
    t.integer  "interests",             default: [],              array: true
    t.string   "avatar_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
