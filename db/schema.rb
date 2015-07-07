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

ActiveRecord::Schema.define(version: 20150706190235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "firefly_api_key"
    t.string   "token_api_key"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "card_number"
    t.string   "exp_date"
    t.string   "cvv"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_code"
    t.string   "full_name"
    t.string   "cust_zip"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "company_id"
    t.string   "token"
  end

  add_index "transactions", ["company_id"], name: "index_transactions_on_company_id", using: :btree

  add_foreign_key "transactions", "companies"
end
