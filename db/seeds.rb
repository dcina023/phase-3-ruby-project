require "faker"

puts "Cleaning up database..."
Meal.destroy_all
MealPlan.destroy_all
User.destroy_all

puts "Seeding 5 users..."
users = 5.times.map do
  User.create!(
    name: Faker::Name.name
  )
end

puts "Seeding meal plans..."
meal_plans = users.flat_map do |user|
  2.times.map do
    MealPlan.create!(
      name: "#{Faker::Food.ethnic_category} Meal Plan",
      week_start: Faker::Date.forward(days: 30),
      goal: ["Meal Prep", "High Protein", "Budget Friendly", "Quick Meals", "Balanced Eating"].sample,
      budget: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      user: user
    )
  end
end

puts "Seeding meals..."
meal_plans.each do |meal_plan|
  5.times do
    Meal.create!(
      name: Faker::Food.dish,
      meal_type: ["Breakfast", "Lunch", "Dinner", "Snack"].sample,
      prep_time: Faker::Number.between(from: 10, to: 90),
      estimated_cost: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      calories: Faker::Number.between(from: 250, to: 900),
      prepared: [true, false].sample,
      favorite: [true, false].sample,
      meal_plan: meal_plan
    )
  end
end

puts "Database seeded successfully!"