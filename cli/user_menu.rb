class CLI
  def list_users
    User.all.each do |user|
      puts "#{user.id}. #{user.name}"
    end
  end

  def user_menu(user)
    loop do
      choice = @prompt.select("\n#{user.name}'s Menu", [
                                { name: "View meal plans and meals", value: :view_meal_plans },
                                { name: "View meal plan summary", value: :meal_plan_summary },
                                { name: "Update meal plans", value: :update_meal_plans },
                                { name: "Update meals", value: :update_meals },
                                { name: "Back to main menu", value: :back },
                              ])

      case choice
      when :view_meal_plans
        meal_plan = select_meal_plan(user)
        if meal_plan
          display_selected_meal_plan(meal_plan)
          display_meals(meal_plan)
        end
      when :meal_plan_summary
        meal_plan = select_meal_plan(user)
        display_meal_plan_summary(meal_plan) if meal_plan
      when :update_meal_plans
        meal_plan_menu(user)
      when :update_meals
        meal_menu(user)
      when :back
        break
      end
    end
  end

  def select_user
    print "Enter a user's name: "
    user_name = gets.chomp.downcase

    user = find_user_by_name(user_name)

    if user
      display_selected_user(user)
      user
    else
      puts "User not found."
      nil
    end
  end

  def add_new_user
    name = prompt_required_text("Add a new user")

    if confirm_action("Are you sure you want to add '#{name}'?")
      user = User.create(name: name)
      puts "Success! '#{user.name}' has been created."
    else
      puts "Adding user canceled."
    end
  end

  def delete_user
    print "Enter user's name to remove: "
    user_name = gets.chomp.downcase

    user = find_user_by_name(user_name)
    if user
      display_selected_user(user)
      user
    else
      puts "User not found."
      return
    end

    if confirm_action("Are you absolutely sure you want to delete '#{user.name}'?")
      user.destroy
      puts "Success! '#{user.name}' has been deleted."
    else
      puts "Deletion canceled."
    end
  end
end
