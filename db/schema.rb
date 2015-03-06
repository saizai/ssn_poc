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

ActiveRecord::Schema.define(version: 20150306173425) do

  create_table "death_master_files", force: :cascade do |t|
    t.string   "social_security_number",   limit: 255
    t.string   "last_name",                limit: 255
    t.string   "name_suffix",              limit: 255
    t.string   "first_name",               limit: 255
    t.string   "middle_name",              limit: 255
    t.string   "verify_proof_code",        limit: 255
    t.date     "date_of_death"
    t.date     "date_of_birth"
    t.string   "state_of_residence",       limit: 255
    t.string   "last_known_zip_residence", limit: 255
    t.string   "last_known_zip_payment",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "as_of"
  end

  add_index "death_master_files", ["as_of"], name: "idx_as_of", using: :btree
  add_index "death_master_files", ["social_security_number"], name: "idx_ssn", unique: true, using: :btree

  create_table "ssn_high_group_codes", force: :cascade do |t|
    t.date     "as_of"
    t.string   "area",       limit: 255
    t.string   "group",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ssn_high_group_codes", ["area", "as_of"], name: "idx_area_as_of", using: :btree
  add_index "ssn_high_group_codes", ["area"], name: "idx_area", using: :btree

end
