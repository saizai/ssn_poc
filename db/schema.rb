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

ActiveRecord::Schema.define(version: 20150408135329) do

  create_table "death_master_files", force: :cascade do |t|
    t.string  "change_type",              limit: 1
    t.integer "ssn_an",                   limit: 2,  unsigned: true
    t.integer "ssn_gn",                   limit: 1,  unsigned: true
    t.integer "ssn_sn",                   limit: 2,  unsigned: true
    t.string  "last_name",                limit: 20
    t.string  "name_suffix",              limit: 4
    t.string  "first_name",               limit: 15
    t.string  "middle_name",              limit: 15
    t.string  "verify_proof_code",        limit: 1
    t.integer "death_month",              limit: 1,  unsigned: true
    t.integer "death_day",                limit: 1,  unsigned: true
    t.integer "death_year",               limit: 2,  unsigned: true
    t.integer "birth_month",              limit: 1,  unsigned: true
    t.integer "birth_day",                limit: 1,  unsigned: true
    t.integer "birth_year",               limit: 2,  unsigned: true
    t.string  "state_of_residence",       limit: 2
    t.string  "last_known_zip_residence", limit: 5
    t.string  "last_known_zip_payment",   limit: 5
    t.string  "extra",                    limit: 7
    t.date    "as_of"
    t.integer "lifespan",                 limit: 3,  unsigned: true
  end

  add_index "death_master_files", ["birth_year", "birth_month", "ssn_an"], name: "idx_dob_ssn", using: :btree
  add_index "death_master_files", ["last_name", "first_name"], name: "idx_last_name_first_name", using: :btree
  add_index "death_master_files", ["last_name", "ssn_an"], name: "idx_last_name_an_dob", using: :btree
  add_index "death_master_files", ["ssn_an", "ssn_gn", "ssn_sn", "as_of"], name: "idx_ssn_as_of", unique: true, using: :btree

  create_table "ssn_high_group_codes", force: :cascade do |t|
    t.date     "as_of"
    t.string   "area",       limit: 255
    t.string   "group",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ssn_high_group_codes", ["area", "as_of"], name: "idx_area_as_of", using: :btree
  add_index "ssn_high_group_codes", ["area"], name: "idx_area", using: :btree

  create_table "states", force: :cascade do |t|
    t.string "name",   limit: 60
    t.string "abbrev", limit: 2
  end

  add_index "states", ["abbrev"], name: "index_states_on_abbrev", unique: true, using: :btree
  add_index "states", ["name"], name: "index_states_on_name", unique: true, using: :btree

end
