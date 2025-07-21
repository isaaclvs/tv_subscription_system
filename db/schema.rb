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

ActiveRecord::Schema[8.0].define(version: 2025_07_21_162825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "due_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id", "item_type", "item_id", "due_date"], name: "index_accounts_uniqueness", unique: true
    t.index ["subscription_id"], name: "index_accounts_on_subscription_id"
  end

  create_table "additional_services", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booklets", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_booklets_on_subscription_id", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.string "month_year", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.date "due_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id", "month_year"], name: "index_invoices_on_subscription_id_and_month_year", unique: true
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id"
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

  create_table "subscription_services", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "additional_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_service_id"], name: "index_subscription_services_on_additional_service_id"
    t.index ["subscription_id", "additional_service_id"], name: "index_subscription_services_uniqueness", unique: true
    t.index ["subscription_id"], name: "index_subscription_services_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "plan_id"
    t.bigint "package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["package_id"], name: "index_subscriptions_on_package_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.check_constraint "plan_id IS NOT NULL AND package_id IS NULL OR plan_id IS NULL AND package_id IS NOT NULL", name: "subscriptions_plan_or_package_xor"
  end

  add_foreign_key "accounts", "subscriptions"
  add_foreign_key "booklets", "subscriptions"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "package_services", "additional_services"
  add_foreign_key "package_services", "packages"
  add_foreign_key "packages", "plans"
  add_foreign_key "subscription_services", "additional_services"
  add_foreign_key "subscription_services", "subscriptions"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "packages"
  add_foreign_key "subscriptions", "plans"
end
