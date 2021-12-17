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

ActiveRecord::Schema.define(version: 2021_12_08_095230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "instrument_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "connector_id"
    t.string "executor_id"
    t.jsonb "connector_credentials", default: {}
    t.jsonb "connector_actions", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["connector_id"], name: "index_instrument_configs_on_connector_id", unique: true
  end

  create_table "instruments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instrument_config_id"
    t.string "external_identifier"
    t.jsonb "value", default: {}
    t.jsonb "connector_actions", default: {}
    t.jsonb "allowed_actions", default: []
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_identifier", "instrument_config_id"], name: "e_i_index"
    t.index ["instrument_config_id"], name: "index_instruments_on_instrument_config_id"
    t.index ["value"], name: "index_instruments_on_value", using: :gin
  end

  create_table "instruments_resources_stores", force: :cascade do |t|
    t.uuid "store_id"
    t.uuid "instrument_id"
    t.uuid "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["instrument_id", "store_id"], name: "i_s_index"
    t.index ["instrument_id"], name: "index_instruments_resources_stores_on_instrument_id"
    t.index ["resource_id"], name: "index_instruments_resources_stores_on_resource_id"
    t.index ["store_id", "instrument_id"], name: "s_i_index"
    t.index ["store_id"], name: "index_instruments_resources_stores_on_store_id"
  end

  create_table "owners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "tags", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tags"], name: "index_owners_on_tags", using: :gin
  end

  create_table "owners_stores", id: false, force: :cascade do |t|
    t.uuid "store_id", null: false
    t.uuid "owner_id", null: false
    t.index ["owner_id", "store_id"], name: "index_owners_stores_on_owner_id_and_store_id"
    t.index ["store_id", "owner_id"], name: "index_owners_stores_on_store_id_and_owner_id"
  end

  create_table "resources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "resource_type"
    t.jsonb "schema", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stores", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "data", default: {}
    t.decimal "value", precision: 15, scale: 2
    t.jsonb "schema", default: {}
    t.jsonb "tags", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tags"], name: "index_stores_on_tags", using: :gin
  end

  create_table "transaction_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "transaction_group_id"
    t.integer "value"
    t.datetime "txn_time"
    t.jsonb "immutable_tags"
    t.jsonb "mutable_tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["immutable_tags"], name: "index_transaction_entries_on_immutable_tags", using: :gin
    t.index ["mutable_tags"], name: "index_transaction_entries_on_mutable_tags", using: :gin
    t.index ["txn_time"], name: "index_transaction_entries_on_txn_time"
  end

  create_table "transaction_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.jsonb "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "instruments", "instrument_configs"
  add_foreign_key "instruments_resources_stores", "instruments"
  add_foreign_key "instruments_resources_stores", "resources"
  add_foreign_key "instruments_resources_stores", "stores"
end
