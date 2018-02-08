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

ActiveRecord::Schema.define(version: 20180207103818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "gender", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "region_id"
    t.index ["region_id"], name: "index_departments_on_region_id"
  end

  create_table "departments_languages", force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_departments_languages_on_department_id"
    t.index ["language_id"], name: "index_departments_languages_on_language_id"
  end

  create_table "directors", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.boolean "current", default: false, null: false
  end

  create_table "involvements", force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "person_id"
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
  end

  create_table "leave_reasons", force: :cascade do |t|
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_reasons_leaves", force: :cascade do |t|
    t.bigint "leave_id"
    t.bigint "leave_reason_id"
    t.index ["leave_id"], name: "index_leave_reasons_leaves_on_leave_id"
    t.index ["leave_reason_id"], name: "index_leave_reasons_leaves_on_leave_reason_id"
  end

  create_table "leaves", force: :cascade do |t|
    t.bigint "person_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_leaves_on_end_date"
    t.index ["person_id"], name: "index_leaves_on_person_id"
    t.index ["start_date"], name: "index_leaves_on_start_date"
  end

  create_table "min_forms", force: :cascade do |t|
    t.string "top_left"
    t.string "top_right"
    t.string "centre"
    t.string "permit_no"
    t.string "decree1"
    t.string "decree1_fr"
    t.string "decree2"
    t.string "decree2_fr"
    t.string "decree3"
    t.string "decree3_fr"
    t.string "decree4"
    t.string "decree4_fr"
    t.string "decree5"
    t.string "decree5_fr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nationalities", force: :cascade do |t|
    t.string "nationality"
  end

  create_table "people", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "category"
    t.string "job"
    t.date "arrival"
    t.date "departure"
    t.string "gender", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cabtal", default: false, null: false
    t.bigint "title_id"
    t.bigint "nationality_id"
    t.string "future_activities"
    t.string "request_period"
    t.index ["nationality_id"], name: "index_people_on_nationality_id"
    t.index ["title_id"], name: "index_people_on_title_id"
  end

  create_table "periodic_documents", force: :cascade do |t|
    t.string "type"
    t.string "quarter"
    t.date "issue_date"
    t.date "expiry_date"
    t.date "submission_date"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.bigint "language_id"
    t.index ["language_id"], name: "index_periodic_documents_on_language_id"
    t.index ["person_id"], name: "index_periodic_documents_on_person_id"
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region_code"
    t.string "en"
    t.string "fr"
    t.string "full_en"
    t.string "full_fr"
  end

  create_table "titles", force: :cascade do |t|
    t.string "title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language", default: 0, null: false
  end

end
