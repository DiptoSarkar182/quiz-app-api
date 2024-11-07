# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'


# # Seed Users
# puts "Seeding Users..."
# 20.times do
#   User.create!(
#     email: Faker::Internet.unique.email,
#     password: '111111',
#     password_confirmation: '111111',
#     full_name: Faker::Name.name,
#     created_at: Time.now,
#     updated_at: Time.now
#   )
# end

puts "Seeding leaderboard points for each user"

User.find_each do |user|
  Leaderboard.create!(
    user: user,
    points: Faker::Number.between(from: 1, to: 1000),
    created_at: Time.now,
    updated_at: Time.now
  )
end