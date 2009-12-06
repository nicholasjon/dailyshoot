# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091206031022) do

  create_table "assignments", :force => true do |t|
    t.string   "text",                        :null => false
    t.date     "date",                        :null => false
    t.string   "tag",                         :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photos_count", :default => 0
  end

  create_table "mentions", :force => true do |t|
    t.integer  "tweet_id",                             :null => false
    t.string   "text",                                 :null => false
    t.integer  "user_id",                              :null => false
    t.string   "screen_name",                          :null => false
    t.string   "profile_image_url",                    :null => false
    t.boolean  "was_parsed",        :default => false
    t.datetime "tweeted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photogs", :force => true do |t|
    t.string   "screen_name",                      :null => false
    t.string   "profile_image_url",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "photos_count",      :default => 0
  end

  add_index "photogs", ["screen_name"], :name => "index_photogs_on_screen_name", :unique => true

  create_table "photos", :force => true do |t|
    t.string   "url",           :null => false
    t.string   "thumb_url",     :null => false
    t.integer  "assignment_id"
    t.integer  "photog_id"
    t.integer  "tweet_id"
    t.datetime "tweeted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "screen_name"
  end

  add_index "photos", ["assignment_id"], :name => "index_photos_on_assignment_id"
  add_index "photos", ["photog_id"], :name => "index_photos_on_photog_id"

  create_table "suggestions", :force => true do |t|
    t.string   "name"
    t.text     "suggestion", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                            :null => false
    t.string   "email",                            :null => false
    t.boolean  "is_admin",      :default => false
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
