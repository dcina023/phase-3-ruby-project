
require "tty-prompt"

class CLI
  def initialize
    @prompt = TTY::Prompt.new
  end

  def run
    puts "Welcome to Meal Prep Tracker!"
    main_menu
  end

  def main_menu
    loop do
      puts "\n1. View users"
      puts "2. Select user"
      puts "3 Update mealplan"
      puts "4. Delete mealplan"
      puts "5. Update meal"
      puts "6. Delete meal"
      puts "7 Exit"
      print "Choose an option: "

      choice = gets.chomp.downcase

      case choice
      when "1", "users"
        list_users
      when "2", "select"
        user = select_user
        select_meal_plan(user) if user
      when "3", "update mealplan"
        update_mealplan
      when "4", "delete mealplan"
        user = select_user
        delete_mealplan(user) if user
      when "5", "update meal"
        update_meal
      when "6", "delete meal"
        delete_meal
      when "7", "exit"
        puts "Goodbye!"
        break
      else
        puts "Invalid choice, try again."
      end
    end
  end

  def list_users
    User.all.each do |user|
      puts "#{user.id}. #{user.name}"
    end
  end

  def select_user
    print "Enter a user's name: "
    user_name = gets.chomp

    user = User.includes(meal_plans: :meals).find_by(name: user_name)

    if user
      puts "\nSelected user: #{user.name} (ID: #{user.id})"
      user
    else
      puts "User not found."
      nil
    end
  end

  def select_meal_plan(user)
    if user.meal_plans.any?
      user.meal_plans.each do |plan|
        puts "  -> Meal Plan: #{plan.name}
        (ID: #{plan.id})
        (week_start: #{plan.week_start})
        (goal: #{plan.goal})
        (budget: #{plan.budget})"
      end

      print "Enter a meal plan ID: "
      meal_plan_id = gets.chomp

      meal_plan = user.meal_plans.find { |plan| plan.id == meal_plan_id.to_i }

      if meal_plan
        meal_plan
      else
        puts "Meal plan not found."
        nil
      end
    else
      puts "No meal plans found."
      nil
    end
  end

  def display_meals(meal_plan)
    if meal_plan.meals.any?
      meal_plan.meals.each do |meal|
        puts "  -> Meal: #{meal.name} (ID: #{meal.id})
          (meal_type: #{meal.meal_type})
          (prep_time: #{meal.prep_time})
          (estimated_cost: #{meal.estimated_cost})
          (calories: #{meal.calories})
          (prepared: #{meal.prepared}
          (favorite: #{meal.favorite})"
      end
    else
      puts "No meals found for this meal plan."
    end
  end

  def select_meal(meal_plan)
    display_meals(meal_plan)

    print "Enter a meal ID: "
    meal_id = gets.chomp

    meal = meal_plan.meals.find { |m| m.id == meal_id.to_i }

    if meal
      meal
    else
      puts "Meal not found."
      nil
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

  def update_meal
    user = select_user
    return unless user

    meal = select_meal(meal_plan)
    return unless meal

    field = @prompt.select("Which field do you want to change?",
                           %w[name meal_type prep_time estimated_cost calories prepared favorite])

    new_value = @prompt.ask("Enter a new value for #{field}:")

    if meal.update(field.to_sym => new_value)
      puts "Success! Record updated in the database."
    else
      puts "Update failed: #{meal.errors.full_messages.join(', ')}"
    end
  end
end
