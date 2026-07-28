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
      puts "3 Add user"
      puts "4. Add mealplan"
      puts "5. Update mealplan"
      puts "6. Delete mealplan"
      puts "7. Add meal"
      puts "8. Update meal"
      puts "9. Delete meal"
      puts "10 Exit"
      print "Choose an option: "

      choice = gets.chomp.downcase

      case choice
      when "1", "users"
        list_users
      when "2", "select"
        user = select_user
        if user
          meal_plan = select_meal_plan(user)
          display_meals(meal_plan) if meal_plan
        end
      when "3", "add user"
        add_new_user
      when "4", "add mealplan"
        add_new_meal_plan
      when "5", "update mealplan"
        update_mealplan
      when "6", "delete mealplan"
        user = select_user
        delete_mealplan(user) if user
      when "7", "add meal"
        add_meal
      when "8", "update meal"
        update_meal
      when "9", "delete meal"
        user = select_user
        delete_meal(user) if user
      when "10", "exit"
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

  def add_new_user
    print "Add a new user:"
    name = gets.chomp

    confirmed = @prompt.yes?("Are you sure you want to add '#{name}'?")

    if confirmed
      user = User.create(name: name)
      puts "Success! '#{user.name}' has been created."
    else
      puts "Adding user canceled."
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

  def display_meals(meal_plan)
    if meal_plan.meals.any?
      meal_plan.meals.each do |meal|
        puts "  -> Meal: #{meal.name} (ID: #{meal.id})"
        puts "     (meal_type: #{meal.meal_type})"
        puts "     (prep_time: #{meal.prep_time})"
        puts "     (estimated_cost: #{meal.estimated_cost})"
        puts "     (calories: #{meal.calories})"
        puts "     (prepared: #{meal.prepared})"
        puts "     (favorite: #{meal.favorite})"
      end
    else
      puts "No meals found for this meal plan."
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

  def update_meal
    user = select_user
    return unless user

    meal_plan = select_meal_plan(user)
    return unless meal_plan

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

  def delete_meal(user)
    user_meals = user.meals

    if user_meals.empty?
      puts "\nYou don't have any meals to delete"
      return
    end

    choices = user_meals.map do |meal|
      { name: "Meal ##{meal.id}: #{meal.name}", value: meal }
    end

    selected_meal = @prompt.select("\nSelect a meal to delete:", choices)

    confirmed = @prompt.yes?("Are you absolutely sure you want to delete? '#{user_meals.name}'?")

    if confirmed
      selected_meal.destroy
      puts "Success! '{selected_meal.name}' has been deleted."
    else
      puts "Deletion canceled."
    end
  end
end
