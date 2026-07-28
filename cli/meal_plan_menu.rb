class CLI
  def select_meal_plan(user)
    if user.meal_plans.empty?
      puts "No meal plans found."
      return nil
    end

    choices = user.meal_plans.map do |plan|
      { name: "#{plan.name} (ID: #{plan.id})", value: plan }
    end

    meal_plan = @prompt.select("Select a meal plan:", choices)

    puts "\nSelected Meal Plan:"
    puts "  -> Meal Plan: #{meal_plan.name}"
    puts "  -> ID: #{meal_plan.id}"
    puts "  -> Week Start: #{meal_plan.week_start}"
    puts "  -> Goal: #{meal_plan.goal}"
    puts "  -> Budget: #{meal_plan.budget}"

    meal_plan
  end

  def display_meal_plan_summary(meal_plan)
    puts "\n#{meal_plan.name} Summary"
    puts "Budget: $#{meal_plan.budget}"
    puts "Estimated Cost: $#{meal_plan.total_estimated_cost}"
    puts "Remaining Budget: $#{meal_plan.remaining_budget}"

    favorite_meals = meal_plan.meals.where(favorite: true)

    puts "\nFavorite Meals:"
    if favorite_meals.any?
      favorite_meals.each do |meal|
        puts "- #{meal.name}"
      end
    else
      puts "No favorite meals found."
    end
  end
end

def add_new_meal_plan
  user = select_user
  return unless user

  print "Meal plan name: "
  name = gets.chomp

  print "Week start date: "
  week_start = gets.chomp

  print "Goal: "
  goal = gets.chomp

  print "Budget: "
  budget = gets.chomp.to_f

  confirmed = @prompt.yes?("Are you sure you want to add '#{name}' meal plan for #{user.name}?")

  if confirmed
    new_meal_plan = user.meal_plans.create(
      name: name,
      week_start: week_start,
      goal: goal,
      budget: budget
    )

    puts "Success! '#{new_meal_plan.name}' has been created."
  else
    puts "Adding meal plan canceled."
  end
end

def update_mealplan
  user = select_user
  return unless user

  meal_plan = select_meal_plan(user)
  return unless meal_plan

  field = @prompt.select("Which field do you want to change?", %w[name week_start goal budget])

  new_value = @prompt.ask("Enter a new value for #{field}:")

  if meal_plan.update(field.to_sym => new_value)
    puts "Success! Record updated in the database."
  else
    puts "Update failed: #{meal_plan.errors.full_messages.join(', ')}"
  end
end

def delete_mealplan(user)
  user_plans = user.meal_plans

  if user_plans.empty?
    puts "\nYou don't have any meal plans to delete"
    return
  end

  choices = user_plans.map do |plan|
    { name: "Plan ##{plan.id}: #{plan.name}", value: plan }
  end

  selected_plan = @prompt.select("\nSelect a meal plan to delete:", choices)

  confirmed = @prompt.yes?("Are you absolutely sure you want to delete? '#{selected_plan.name}'?")

  if confirmed
    selected_plan.destroy
    puts "Success! '{selected_plan.name}' has been deleted."
  else
    puts "Deletion canceled."
  end
end
