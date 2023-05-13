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

ActiveRecord::Schema[7.0].define(version: 2023_05_13_185626) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "disbursments", force: :cascade do |t|
    t.float "commission"
    t.float "merchant_payment"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_disbursments_on_order_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "merchant_reference"
    t.string "email"
    t.datetime "live_on"
    t.integer "frequency"
    t.float "minimum_monthly_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_fees", force: :cascade do |t|
    t.float "amount"
    t.bigint "disbursment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disbursment_id"], name: "index_monthly_fees_on_disbursment_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "merchant_reference"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "disbursments", "orders"
  add_foreign_key "monthly_fees", "disbursments"
end
