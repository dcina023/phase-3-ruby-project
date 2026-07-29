class Main
  def meal_menu(user)
    meal_plan = select_meal_plan(user)
    return unless meal_plan

    loop do
      choice = @prompt.select("Update meals for #{meal_plan.name}", [
                                { name: "Add meal", value: :add },
                                { name: "Edit meal", value: :edit },
                                { name: "Delete meal", value: :delete },
                                { name: "Back", value: :back },
                              ])

      case choice
      when :add
        add_new_meal(meal_plan) if meal_plan
      when :edit
        update_meal(meal_plan) if meal_plan
      when :delete
        delete_meal(meal_plan) if meal_plan
      when :back
        break
      end
    end
  end

  def display_meals(meal_plan)
    if meal_plan.meals.any?
      meal_plan.meals.each do |meal|
        puts "  -> Meal: #{meal.name} (ID: #{meal.id})"
        puts "     (meal_type: #{meal.meal_type})"
        puts "     (prep_time: #{format_prep_time(meal.prep_time)})"
        puts "     (estimated_cost: #{meal.estimated_cost})"
        puts "     (calories: #{meal.calories})"
        puts "     (prepared: #{meal.prepared})"
        puts "     (favorite: #{meal.favorite})"
      end
    else
      puts "No meals found for this meal plan."
    end
  end

  def add_new_meal(meal_plan)
    name = prompt_required("Meal name")
    meal_type = prompt_required_text("Meal type")
    prep_time = prompt_prep_time
    estimated_cost = prompt_float("Estimated cost")
    calories = prompt_integer("Calories")
    favorite = prompt_boolean("Favorite?")

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

  def update_meal(meal_plan)
    meal = select_meal(meal_plan)
    return unless meal

    field = @prompt.select("Which field do you want to change?",
                           %w[name meal_type prep_time estimated_cost calories prepared favorite])

    new_value =
      case field
      when "name", "meal_type"
        prompt_required_text("Enter a new value for #{field}")
      when "prep_time"
        prompt_prep_time
      when "calories"
        prompt_integer("Enter a new value for #{field}")
      when "estimated_cost"
        prompt_float("Enter a new value for #{field}")
      when "prepared", "favorite"
        @prompt.yes?("#{field.capitalize}?")
      end

    if meal.update(field.to_sym => new_value)
      puts "Success! Record updated in the database."
    else
      puts "Update failed: #{meal.errors.full_messages.join(', ')}"
    end
  end

  def delete_meal(meal_plan)
    if meal_plan.meals.empty?
      puts "\nYou don't have any meals to delete"
      return
    end

    choices = meal_plan.meals.map do |meal|
      { name: "Meal ##{meal.id}: #{meal.name}", value: meal }
    end

    selected_meal = @prompt.select("\nSelect a meal to delete:", choices)

    confirmed = @prompt.yes?("Are you absolutely sure you want to delete '#{selected_meal.name}'?")

    if confirmed
      selected_meal.destroy
      puts "Success! '#{selected_meal.name}' has been deleted."
    else
      puts "Deletion canceled."
    end
  end
end
