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

ActiveRecord::Schema.define(version: 20140802235616) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
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

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "feed_post_comments", force: true do |t|
    t.integer  "feed_post_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_post_comments", ["feed_post_id"], name: "index_feed_post_comments_on_feed_post_id", using: :btree
  add_index "feed_post_comments", ["user_id"], name: "index_feed_post_comments_on_user_id", using: :btree

  create_table "feed_post_votes", force: true do |t|
    t.integer  "feed_post_id"
    t.integer  "user_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_post_votes", ["feed_post_id"], name: "index_feed_post_votes_on_feed_post_id", using: :btree
  add_index "feed_post_votes", ["user_id"], name: "index_feed_post_votes_on_user_id", using: :btree

  create_table "feed_posts", force: true do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "post"
    t.text     "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flaggings_count"
  end

  add_index "feed_posts", ["feed_id"], name: "index_feed_posts_on_feed_id", using: :btree
  add_index "feed_posts", ["user_id"], name: "index_feed_posts_on_user_id", using: :btree

  create_table "feeds", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flaggings", force: true do |t|
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.string   "flagger_type"
    t.integer  "flagger_id"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flaggings", ["flaggable_type", "flaggable_id"], name: "index_flaggings_on_flaggable_type_and_flaggable_id", using: :btree
  add_index "flaggings", ["flagger_type", "flagger_id", "flaggable_type", "flaggable_id"], name: "access_flaggings", using: :btree

  create_table "follows", force: true do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "likes", force: true do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "mentions", force: true do |t|
    t.string   "mentioner_type"
    t.integer  "mentioner_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "store_item_review_comments", force: true do |t|
    t.integer  "store_item_review_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_item_review_comments", ["store_item_review_id"], name: "index_store_item_review_comments_on_store_item_review_id", using: :btree
  add_index "store_item_review_comments", ["user_id"], name: "index_store_item_review_comments_on_user_id", using: :btree

  create_table "store_item_review_votes", force: true do |t|
    t.integer  "store_item_review_id"
    t.integer  "user_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_item_review_votes", ["store_item_review_id"], name: "index_store_item_review_votes_on_store_item_review_id", using: :btree
  add_index "store_item_review_votes", ["user_id"], name: "index_store_item_review_votes_on_user_id", using: :btree

  create_table "store_item_reviews", force: true do |t|
    t.integer  "store_item_id"
    t.integer  "user_id"
    t.text     "review"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stars"
  end

  add_index "store_item_reviews", ["store_item_id"], name: "index_store_item_reviews_on_store_item_id", using: :btree
  add_index "store_item_reviews", ["user_id"], name: "index_store_item_reviews_on_user_id", using: :btree

  create_table "store_items", force: true do |t|
    t.integer  "store_id"
    t.text     "name"
    t.text     "description"
    t.float    "thc"
    t.float    "cbd"
    t.float    "cbn"
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
    t.integer  "costperunit"
    t.string   "maincategory"
    t.string   "strain"
    t.string   "subcategory"
    t.string   "cultivation"
    t.boolean  "privatereserve"
    t.boolean  "topshelf"
    t.boolean  "supersize"
    t.boolean  "glutenfree"
    t.boolean  "sugarfree"
    t.boolean  "organic"
    t.float    "dose"
    t.boolean  "og"
    t.boolean  "kush"
    t.boolean  "haze"
    t.text     "promo"
    t.integer  "syncid"
    t.string   "image_url"
  end

  add_index "store_items", ["store_id"], name: "index_store_items_on_store_id", using: :btree

  create_table "store_review_comments", force: true do |t|
    t.integer  "store_review_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_review_comments", ["store_review_id"], name: "index_store_review_comments_on_store_review_id", using: :btree
  add_index "store_review_comments", ["user_id"], name: "index_store_review_comments_on_user_id", using: :btree

  create_table "store_review_votes", force: true do |t|
    t.integer  "store_review_id"
    t.integer  "user_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_review_votes", ["store_review_id"], name: "index_store_review_votes_on_store_review_id", using: :btree
  add_index "store_review_votes", ["user_id"], name: "index_store_review_votes_on_user_id", using: :btree

  create_table "store_reviews", force: true do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.text     "review"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stars"
    t.integer  "flaggings_count"
  end

  add_index "store_reviews", ["store_id"], name: "index_store_reviews_on_store_id", using: :btree
  add_index "store_reviews", ["user_id"], name: "index_store_reviews_on_user_id", using: :btree

  create_table "stores", force: true do |t|
    t.text     "name"
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
    t.string   "email"
    t.text     "description"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.boolean  "eighteenplus"
    t.boolean  "twentyoneplus"
    t.boolean  "labtested"
    t.boolean  "hasphotos"
    t.text     "announcement"
    t.boolean  "onsitetesting"
    t.text     "deliveryarea"
    t.string   "filepath"
    t.integer  "storehourssundayopenhour"
    t.integer  "storehourssundayopenminute"
    t.integer  "storehourssundayclosehour"
    t.integer  "storehourssundaycloseminute"
    t.integer  "storehoursmondayopenhour"
    t.integer  "storehoursmondayopenminute"
    t.integer  "storehoursmondayclosehour"
    t.integer  "storehoursmondaycloseminute"
    t.integer  "storehourstuesdayopenhour"
    t.integer  "storehourstuesdayopenminute"
    t.integer  "storehourstuesdayclosehour"
    t.integer  "storehourstuesdaycloseminute"
    t.integer  "storehourswednesdayopenhour"
    t.integer  "storehourswednesdayopenminute"
    t.integer  "storehourswednesdayclosehour"
    t.integer  "storehourswednesdaycloseminute"
    t.integer  "storehoursthursdayopenhour"
    t.integer  "storehoursthursdayopenminute"
    t.integer  "storehoursthursdayclosehour"
    t.integer  "storehoursthursdaycloseminute"
    t.integer  "storehoursfridayopenhour"
    t.integer  "storehoursfridayopenminute"
    t.integer  "storehoursfridayclosehour"
    t.integer  "storehoursfridaycloseminute"
    t.integer  "storehourssaturdayopenhour"
    t.integer  "storehourssaturdayopenminute"
    t.integer  "storehourssaturdayclosehour"
    t.integer  "storehourssaturdaycloseminute"
    t.boolean  "sundayclosed"
    t.boolean  "mondayclosed"
    t.boolean  "tuesdayclosed"
    t.boolean  "wednesdayclosed"
    t.boolean  "thursdayclosed"
    t.boolean  "fridayclosed"
    t.boolean  "saturdayclosed"
    t.integer  "syncid"
    t.text     "promo"
    t.string   "avatar_url"
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
    t.boolean  "admin"
    t.string   "username"
    t.integer  "flaggings_count"
    t.string   "avatar_url"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
