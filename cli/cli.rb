require "tty-prompt"
# core navigation
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
        add_new_meal
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
end
