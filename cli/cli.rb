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
      puts "----------------------------
---------------------------- "
      choice = @prompt.select("Main Menu", [
                                { name: "View users", value: :view_users },
                                { name: "Select user", value: :select_user },
                                { name: "Add user", value: :add_user },
                                { name: "Delete user", value: :delete_user },
                                { name: "Exit", value: :exit },
                              ])

      case choice
      when :view_users
        list_users
      when :select_user
        user = select_user
        user_menu(user) if user
      when :add_user
        add_new_user
      when :delete_user
        delete_user
      when :exit
        puts "Thank you for using Meal Plan Tracker!"
        break
      end
    end
  end
end
