class CLI
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

  def user_menu(user)
    loop do
      choice = @prompt.select("\n#{user.name}'s Menu", [
        { name: "View meal plans and meals", value: :view_meal_plans },
        { name: "View meal plan summary", value: :meal_plan_summary },
        { name: "Back to main menu", value: :back }
      ])

      case choice
      when :view_meal_plans
        meal_plan = select_meal_plan(user)
        display_meals(meal_plan) if meal_plan
      when :meal_plan_summary
        meal_plan = select_meal_plan(user)
        display_meal_plan_summary(meal_plan) if meal_plan
      when :back
        break
      end
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
end
