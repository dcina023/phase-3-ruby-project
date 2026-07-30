#!/usr/bin/env ruby
require_relative "../config/environment"
require_relative "input_helpers"
require_relative "user_menu"
require_relative "meal_plan_menu"
require_relative "meal_menu"
require "tty-prompt"
require "tty-font"
require "pastel"

class CLI
  def initialize
    @prompt = TTY::Prompt.new
    @font = TTY::Font.new(:standard)
    @pastel = Pastel.new
  end

  def run

    print "\e[H\e[2J"
    puts @pastel.green(@font.write("Meal Prep Tracker"))

    main_menu
  ensure
    ActiveRecord::Base.connection_pool.disconnect! if ActiveRecord::Base.connected?
  end

  def main_menu
    loop do
      puts @pastel.dim("—" * 50)
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
        puts @pastel.blue(@font.write("Thank you!"))
        break
      end
    end
  end
end

CLI.new.run
