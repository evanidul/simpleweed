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

ActiveRecord::Schema.define(version: 20140320102107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "store_items", force: true do |t|
    t.integer  "store_id"
    t.string   "name"
    t.string   "description"
    t.integer  "thc"
    t.integer  "cbd"
    t.integer  "cbn"
    t.integer  "costhalfgram"
    t.integer  "costonegram"
    t.integer  "costeighthoz"
    t.integer  "costquarteroz"
    t.integer  "costhalfoz"
    t.integer  "costoneoz"
    t.boolean  "dogo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_items", ["store_id"], name: "index_store_items_on_store_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "addressline1"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phonenumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dailyspecialsmonday"
    t.string   "dailyspecialstuesday"
    t.string   "dailyspecialswednesday"
    t.string   "dailyspecialsthursday"
    t.string   "dailyspecialsfriday"
    t.string   "dailyspecialssaturday"
    t.string   "dailyspecialssunday"
    t.boolean  "acceptscreditcards"
    t.boolean  "automaticdispensingmachines"
    t.boolean  "firsttimepatientdeals"
    t.boolean  "handicapaccess"
    t.boolean  "loungearea"
    t.boolean  "petfriendly"
    t.boolean  "securityguard"
    t.boolean  "atmaccess"
    t.boolean  "deliveryservice"
  end

end
