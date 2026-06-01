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

ActiveRecord::Schema[8.1].define(version: 2026_06_01_000004) do
  create_table "products", force: :cascade do |t|
    t.string "accessory_type"
    t.boolean "active", default: true, null: false
    t.string "brand"
    t.string "category", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "imei"
    t.string "model_number"
    t.string "name", null: false
    t.decimal "purchase_price", precision: 10, scale: 2
    t.integer "quantity", default: 0, null: false
    t.decimal "selling_price", precision: 10, scale: 2, null: false
    t.string "storage"
    t.datetime "updated_at", null: false
    t.index ["brand"], name: "index_products_on_brand"
    t.index ["category"], name: "index_products_on_category"
    t.index ["imei"], name: "index_products_on_imei", unique: true, where: "imei IS NOT NULL"
    t.index ["name", "brand", "category"], name: "index_products_on_name_and_brand_and_category"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.text "notes"
    t.string "payment_method", default: "cash", null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.string "salesman_name"
    t.datetime "sold_at", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_sales_on_product_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "sales", "products"
  add_foreign_key "sales", "users"
end
