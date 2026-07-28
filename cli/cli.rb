class CLI
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
        select_user
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

    user = User.find_by(id: user_id)

    if user
      puts "Selected user: #{user.name}"
    else
      puts "User not found."
    end
  end
end
