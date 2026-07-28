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
      puts "5. Add meal"
      puts "6. Update meal"
      puts "7. Delete meal"
      puts "8 Exit"
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
        delete_mealplan
      when "5", "add meal"
        add_meal
      when "6", "update meal"
        update_meal
      when "7", "delete meal"
        delete_meal
      when "8", "exit"
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
    print "Enter a user ID: "
    user_id = gets.chomp

    user = User.includes(meal_plans: :meals).find_by(id: user_id)

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

      print "Enter a meal plan ID to view meals: "
      meal_plan_id = gets.chomp

      selected_plan = user.meal_plans.find { |plan| plan.id == meal_plan_id.to_i }

      if selected_plan
        selected_plan.meals.each do |meal|
          puts " -> Meal: #{meal.name} (ID: #{meal.id}) 
          (meal_type: #{meal.meal_type})
          (prep_time: #{meal.prep_time})
          (estimated_cost: #{meal.estimated_cost})
          (calories: #{meal.calories})
          (prepared: #{meal.prepared}
          (favorite: #{meal.favorite})"
        end

        selected_plan
      else
        puts "Meal plan not found."
        nil
      end
    else
      puts "  -> No meal plans found."
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
end
