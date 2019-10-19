# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Include didn't work...
require_relative "../lib/seed_manager"

Artist.destroy_all
Addition.destroy_all


SeedManager.seed_from_youtube("PLAV1qP_iCfWmv8rq9JVj_I0BZtqDJdmZo")
SeedManager.seed_from_spotify("4CalfhTMITrzxqrgtIVMcv")
SeedManager.seed_from_vinyl({artist: "AC/DC", album: "Powerage"})


puts "Generated #{Track.count} tracks"
puts "Generated #{Album.count} albums"
puts "Generated #{Artist.count} artists"