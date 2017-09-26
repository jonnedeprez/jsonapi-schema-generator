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

ActiveRecord::Schema.define(version: 20170921145846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "contract_id", null: false
    t.bigint "entity_id", null: false
    t.string "request_type", default: "GET", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_actions_on_contract_id"
    t.index ["entity_id"], name: "index_actions_on_entity_id"
  end

  create_table "actions_entities", id: false, force: :cascade do |t|
    t.bigint "action_id", null: false
    t.bigint "entity_id", null: false
    t.index ["action_id"], name: "index_actions_entities_on_action_id"
    t.index ["entity_id"], name: "index_actions_entities_on_entity_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "client", null: false
    t.string "server", null: false
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_entities_on_contract_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "field_type", default: "string"
    t.boolean "required"
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_fields_on_entity_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "dependent_entity_id", null: false
    t.string "cardinality", default: "BELONGS_TO", null: false
    t.boolean "required", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["dependent_entity_id"], name: "index_relationships_on_dependent_entity_id"
    t.index ["entity_id"], name: "index_relationships_on_entity_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  add_foreign_key "actions", "contracts"
  add_foreign_key "actions", "entities"
  add_foreign_key "contracts", "users"
  add_foreign_key "entities", "contracts"
  add_foreign_key "fields", "entities"
  add_foreign_key "relationships", "entities"
end
