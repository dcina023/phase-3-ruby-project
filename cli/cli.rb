class CLI
  def run
    puts "Welcome to Meal Prep Tracker!"
    main_menu
  end

  def main_menu
    loop do
      puts "\n1. View users"
      puts "2. Select user"
      puts "3. Exit"
      print "Choose an option: "

      choice = gets.chomp.downcase

      case choice
      when "1", "users"
        list_users
      when "2", "select"
        select_user
      when "3", "exit"
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