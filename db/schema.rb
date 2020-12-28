# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_930_104_214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'segments', force: :cascade do |t|
    t.integer 'station_a_id', null: false
    t.integer 'station_b_id', null: false
    t.integer 'travel_time'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'tram_line_id', null: false
    t.index ['tram_line_id'], name: 'index_segments_on_tram_line_id'
  end

  create_table 'stations', force: :cascade do |t|
    t.string 'name'
    t.string 'simple_name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['simple_name'], name: 'index_stations_on_simple_name', unique: true
  end

  create_table 'tram_lines', force: :cascade do |t|
    t.string 'name'
    t.boolean 'outgoing'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'segments', 'tram_lines'
end
