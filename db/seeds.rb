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
      budget: Faker::Number.between(from: 75, to: 200),
      user: user
    )
  end
end

puts "Seeding meals..."
meal_plans.each do |meal_plan|
  5.times do
    remaining_budget = meal_plan.remaining_budget
    break if remaining_budget <= 0

    estimated_cost = Faker::Number.between(
      from: 5,
      to: [remaining_budget, 30].min
    ).round(2)

    prep_hours = Faker::Number.between(from: 0, to: 2)
    prep_minutes = Faker::Number.between(from: 0, to: 59)
    prep_time = (prep_hours * 60) + prep_minutes

    Meal.create!(
      name: Faker::Food.dish,
      meal_type: ["Breakfast", "Lunch", "Dinner", "Snack"].sample,
      prep_time: prep_time,
      estimated_cost: estimated_cost,
      calories: Faker::Number.between(from: 250, to: 900),
      prepared: [true, false].sample,
      favorite: [true, false].sample,
      meal_plan: meal_plan
    )
  end
end

puts "Database seeded successfully!"