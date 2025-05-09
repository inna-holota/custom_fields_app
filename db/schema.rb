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

ActiveRecord::Schema[8.0].define(version: 2025_04_27_210718) do
  create_table "custom_field_options", force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_options_on_custom_field_id"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "custom_field_id", null: false
    t.integer "custom_field_option_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_values_on_custom_field_id"
    t.index ["custom_field_option_id"], name: "index_custom_field_values_on_custom_field_option_id"
    t.index ["user_id", "custom_field_id", "custom_field_option_id"], name: "custom_field_values_uniquness", unique: true
    t.index ["user_id"], name: "index_custom_field_values_on_user_id"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.integer "tenant_id", null: false
    t.string "name", null: false
    t.integer "field_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "name"], name: "index_custom_fields_on_tenant_id_and_name", unique: true
    t.index ["tenant_id"], name: "index_custom_fields_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tenant_id", null: false
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "custom_field_options", "custom_fields"
  add_foreign_key "custom_field_values", "custom_field_options"
  add_foreign_key "custom_field_values", "custom_fields"
  add_foreign_key "custom_field_values", "users"
  add_foreign_key "custom_fields", "tenants"
  add_foreign_key "users", "tenants"
end
