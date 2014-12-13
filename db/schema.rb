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

ActiveRecord::Schema.define(version: 20141203063735) do

  create_table "admins", force: true do |t|
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
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "blog_comments", force: true do |t|
    t.text     "comment"
    t.integer  "rating"
    t.integer  "likes"
    t.integer  "external_post_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "post_id"
  end

  add_index "blog_comments", ["post_id"], name: "index_blog_comments_on_post_id"

  create_table "partner_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "url"
    t.text     "comment"
    t.string   "img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_type_id"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "post_date"
  end

  create_table "process_steps", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "step_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", force: true do |t|
    t.string   "loan_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.integer  "question_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
