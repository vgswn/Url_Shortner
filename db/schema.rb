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

ActiveRecord::Schema.define(version: 2019_01_31_064503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "domain_prefixes", force: :cascade do |t|
    t.string "domain"
    t.string "prefix"
    t.index ["domain"], name: "index_domain_prefixes_on_domain"
  end

  create_table "reports", force: :cascade do |t|
    t.string "date"
    t.integer "no_of_urls"
  end

  create_table "urls", force: :cascade do |t|
    t.string "long_url"
    t.string "short_url"
    t.string "domain"
    t.index ["long_url"], name: "index_urls_on_long_url"
    t.index ["short_url"], name: "index_urls_on_short_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "views", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_views_on_email", unique: true
    t.index ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true
  end

end
