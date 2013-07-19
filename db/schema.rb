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

ActiveRecord::Schema.define(version: 20130715063518) do

  create_table "attendance_remarks", force: true do |t|
    t.integer "student_attendance_id"
    t.text    "label"
    t.text    "in_text"
  end

  create_table "student_attendances", force: true do |t|
    t.integer  "student_id"
    t.datetime "arrival"
    t.datetime "leave"
  end

  create_table "students", force: true do |t|
    t.integer  "student_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "english_name"
    t.string   "chinese_name"
    t.string   "gender"
    t.datetime "date_of_birth"
    t.string   "school_eng_name"
    t.string   "school_chi_name"
    t.integer  "self_tel"
    t.integer  "parents_tel"
    t.integer  "contact_tel"
    t.string   "email"
    t.string   "address"
    t.datetime "admission_date"
    t.string   "refer_from"
  end

end
