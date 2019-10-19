# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_19_013207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additions", force: :cascade do |t|
    t.string "addition_type"
    t.string "id_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "album_maps", force: :cascade do |t|
    t.string "input"
    t.bigint "album_id", null: false
    t.integer "scope"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_album_maps_on_album_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "title"
    t.string "image_url"
    t.bigint "artist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artist_maps", force: :cascade do |t|
    t.string "input"
    t.bigint "artist_id", null: false
    t.index ["artist_id"], name: "index_artist_maps_on_artist_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "title"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "formats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "formattings", force: :cascade do |t|
    t.bigint "format_id", null: false
    t.bigint "track_id", null: false
    t.bigint "addition_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addition_id"], name: "index_formattings_on_addition_id"
    t.index ["format_id"], name: "index_formattings_on_format_id"
    t.index ["track_id"], name: "index_formattings_on_track_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["track_id"], name: "index_taggings_on_track_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "artist_id", null: false
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  add_foreign_key "album_maps", "albums"
  add_foreign_key "albums", "artists"
  add_foreign_key "artist_maps", "artists"
  add_foreign_key "formattings", "additions"
  add_foreign_key "formattings", "formats"
  add_foreign_key "formattings", "tracks"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "artists"
end
