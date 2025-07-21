# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_21_151238) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "additional_services", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "package_services", force: :cascade do |t|
    t.bigint "package_id", null: false
    t.bigint "additional_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_service_id"], name: "index_package_services_on_additional_service_id"
    t.index ["package_id", "additional_service_id"], name: "index_package_services_uniqueness", unique: true
    t.index ["package_id"], name: "index_package_services_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.bigint "plan_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_packages_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "package_services", "additional_services"
  add_foreign_key "package_services", "packages"
  add_foreign_key "packages", "plans"
end
