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

ActiveRecord::Schema.define(version: 20180108152049) do

  create_table "involvements", force: :cascade do |t|
    t.integer "language_id"
    t.integer "person_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_involvements_on_language_id"
    t.index ["person_id"], name: "index_involvements_on_person_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.index ["region_id"], name: "index_languages_on_region_id"
  end

  create_table "leave_reasons", force: :cascade do |t|
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_reasons_leaves", force: :cascade do |t|
    t.integer "leave_id"
    t.integer "leave_reason_id"
    t.index ["leave_id"], name: "index_leave_reasons_leaves_on_leave_id"
    t.index ["leave_reason_id"], name: "index_leave_reasons_leaves_on_leave_reason_id"
  end

  create_table "leaves", force: :cascade do |t|
    t.integer "person_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_leaves_on_end_date"
    t.index ["person_id"], name: "index_leaves_on_person_id"
    t.index ["start_date"], name: "index_leaves_on_start_date"
  end

  create_table "people", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "category"
    t.string "job"
    t.date "arrival"
    t.date "departure"
    t.string "nationality"
    t.string "title"
    t.string "gender", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periodic_documents", force: :cascade do |t|
    t.string "type"
    t.string "quarter"
    t.date "issue_date"
    t.date "expiry_date"
    t.date "submission_date"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_periodic_documents_on_person_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
