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

ActiveRecord::Schema.define(version: 20140428045117) do

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
    t.string   "category"
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
    t.text     "firsttimepatientdeals"
    t.boolean  "handicapaccess"
    t.boolean  "loungearea"
    t.boolean  "petfriendly"
    t.boolean  "securityguard"
    t.boolean  "atmaccess"
    t.boolean  "deliveryservice"
    t.string   "addressline2"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "storehourssunday"
    t.string   "storehoursmonday"
    t.string   "storehourstuesday"
    t.string   "storehourswednesday"
    t.string   "storehoursthursday"
    t.string   "storehoursfriday"
    t.string   "storehourssaturday"
    t.integer  "storehourssundayopen"
    t.integer  "storehourssundayclosed"
    t.integer  "storehoursmondayopen"
    t.integer  "storehoursmondayclosed"
    t.integer  "storehourstuesdayopen"
    t.integer  "storehourstuesdayclosed"
    t.integer  "storehourswednesdayopen"
    t.integer  "storehourswednesdayclosed"
    t.integer  "storehoursthursdayopen"
    t.integer  "storehoursthursdayclosed"
    t.integer  "storehoursfridayopen"
    t.integer  "storehoursfridayclosed"
    t.integer  "storehourssaturdayopen"
    t.integer  "storehourssaturdayclosed"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
