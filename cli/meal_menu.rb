class CLI
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

  def add_new_meal
    user = select_user
    return unless user

    meal_plan = select_meal_plan(user)
    return unless meal_plan

    print "Meal name: "
    name = gets.chomp

    print "Meal type: "
    meal_type = gets.chomp

    print "Prep time: "
    prep_time = gets.chomp.to_i

    print "Estimated Cost: "
    estimated_cost = gets.chomp.to_f

    print "Calories: "
    calories = gets.chomp.to_i

    favorite = @prompt.yes?("Favorite?")

    confirmed = @prompt.yes?("Are you sure you want to add '#{name}' meal to #{meal_plan.name}?")

    if confirmed
      new_meal = meal_plan.meals.create(
        name: name,
        meal_type: meal_type,
        prep_time: prep_time,
        estimated_cost: estimated_cost,
        calories: calories,
        favorite: favorite
      )

      puts "Success! '#{new_meal.name}' has been created."
    else
      puts "Adding meal canceled."
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
