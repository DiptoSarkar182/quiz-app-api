# Seed Users

puts "inserting dipto and mr. bean"

User.create!(
  email: "dipto@gmail.com",
  password: '111111',
  password_confirmation: '111111',
  full_name: "Dipto Sarkar",
  created_at: Time.now,
  updated_at: Time.now
)

User.create!(
  email: "bean@gmail.com",
  password: '111111',
  password_confirmation: '111111',
  full_name: "Mr. Bean",
  created_at: Time.now,
  updated_at: Time.now
)

puts "Seeding Users..."
80.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: '111111',
    password_confirmation: '111111',
    full_name: Faker::Name.name,
    created_at: Time.now,
    updated_at: Time.now
  )
end

puts "Updating leaderboard points for each user"

# Update leaderboard entries for existing users
User.find_each do |user|
  if user.leaderboard
    user.leaderboard.update!(
      points: Faker::Number.between(from: 1, to: 1000)
    )
  end
end

puts "Updated leaderboard points for each user."

# Dividing the existing users into three groups
users = User.all
total_users = users.count
third_size = total_users / 3

# Group users into three: daily, weekly, and monthly
daily_users = users[0...third_size]
weekly_users = users[third_size...(2 * third_size)]
monthly_users = users[(2 * third_size)..-1]

# Update leaderboard `updated_at` for daily users (today)
daily_users.each do |user|
  if user.leaderboard
    user.leaderboard.update!(updated_at: Time.zone.now)
  end
end

# Update leaderboard `updated_at` for weekly users (within the past 7 days)
weekly_users.each do |user|
  if user.leaderboard
    user.leaderboard.update!(updated_at: Time.zone.now - rand(1..7).days)
  end
end

# Update leaderboard `updated_at` for monthly users (within the past 30 days)
monthly_users.each do |user|
  if user.leaderboard
    user.leaderboard.update!(updated_at: Time.zone.now - rand(8..30).days)
  end
end

puts "Updated leaderboard timestamps for daily, weekly, and monthly users."


# Create 5 random friend for current user dipto (friends)
current_user = User.find_by(email: "dipto@gmail.com")

# Fetch 5 random users from the database, excluding the current user
friends = User.where.not(id: current_user.id).order(Arel.sql('RANDOM()')).limit(5)

# Create bidirectional friendships for the selected users
friends.each do |friend|
  # Add the friend to the current user's friend list
  current_user.friend_lists.create!(friend_id: friend.id)

  # Add the current user to the friend's friend list
  friend.friend_lists.create!(friend_id: current_user.id)
end

puts "Created 5 friends for user with email dipto@gmail.com"

# Creating 10 random quiz category
unique_titles = Set.new

while unique_titles.size < 10
  title = Faker::Educator.subject
  unique_titles.add(title) unless unique_titles.include?(title)
end

unique_titles.each do |title|
  Category.create(title: title)
end

puts "10 unique quiz categories created!"

# Creating some unique sub-category
Category.find_each do |category|
  unique_sub_titles = Set.new

  while unique_sub_titles.size < 10
    sub_title = Faker::Educator.course_name
    unique_sub_titles.add(sub_title) unless unique_sub_titles.include?(sub_title)
  end

  unique_sub_titles.each do |sub_title|
    SubCategory.create(category_id: category.id, title: sub_title)
  end
end

puts "10 unique subcategories created for each category!"