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

ActiveRecord::Schema.define(version: 20191223085122) do

  create_table "device_locations", force: :cascade do |t|
    t.string   "loc_ident",     null: false
    t.string   "desc"
    t.integer  "iot_device_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["iot_device_id"], name: "index_device_locations_on_iot_device_id"
    t.index ["loc_ident"], name: "index_device_locations_on_loc_ident", unique: true
  end

  create_table "iot_devices", force: :cascade do |t|
    t.string   "uname",      null: false
    t.string   "model"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uname"], name: "index_iot_devices_on_uname", unique: true
  end

  create_table "ip_restrictions", force: :cascade do |t|
    t.string   "list_type",                 null: false
    t.string   "ip",                        null: false
    t.string   "desc"
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "tph_records", force: :cascade do |t|
    t.datetime "dt",            null: false
    t.float    "t"
    t.float    "p"
    t.float    "h"
    t.integer  "iot_device_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["iot_device_id", "dt"], name: "index_tph_records_on_iot_device_id_and_dt", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
