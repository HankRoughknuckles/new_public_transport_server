# typed: strict
require 'lines'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ALL_LINES.each do |line_info|
  puts "Seeding DB for #{line_info[:name]}"
  TramLine.from_station_names(
    line_info[:name], line_info[:outgoing], line_info[:station_names]
  )
end
