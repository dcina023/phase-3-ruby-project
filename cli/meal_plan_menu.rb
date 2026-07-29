class Main
  def meal_plan_menu(user)
    loop do
      choice = @prompt.select("Update meal plans for #{user.name}", [
                                { name: "Add meal plan", value: :add },
                                { name: "Edit meal plan", value: :edit },
                                { name: "Delete meal plan", value: :delete },
                                { name: "Back", value: :back },
                              ])

      case choice
      when :add
        add_new_meal_plan(user)
      when :edit
        meal_plan = select_meal_plan(user)
        update_meal_plan(meal_plan) if meal_plan
      when :delete
        meal_plan = select_meal_plan(user)
        delete_meal_plan(meal_plan) if meal_plan
      when :back
        break
      end
    end
  end

  def display_meal_plan_summary(meal_plan)
    puts "\n#{meal_plan.name} Summary"
    puts "Budget: $#{meal_plan.budget}"
    puts "Estimated Cost: $#{meal_plan.total_estimated_cost}"
    puts "Remaining Budget: $#{meal_plan.remaining_budget}"

    favorite_meals = meal_plan.meals.where(favorite: true)

    puts "\nFavorite Meals:"
    if favorite_meals.any?
      favorite_meals.each do |meal|
        puts "- #{meal.name}"
      end
    else
      puts "No favorite meals found."
    end
  end

  def select_meal_plan(user)
    if user.meal_plans.empty?
      puts "No meal plans found."
      return nil
    end

    choices = user.meal_plans.map do |plan|
      { name: "#{plan.name} (ID: #{plan.id})", value: plan }
    end

    meal_plan = @prompt.select("Select a meal plan:", choices)

    puts "\nSelected Meal Plan:"
    puts "  -> Meal Plan: #{meal_plan.name}"
    puts "  -> ID: #{meal_plan.id}"
    puts "  -> Week Start: #{meal_plan.week_start}"
    puts "  -> Goal: #{meal_plan.goal}"
    puts "  -> Budget: #{meal_plan.budget}"

    meal_plan
  end

  def add_new_meal_plan(user)
    name = prompt_required_text("Meal plan name")
    week_start = prompt_date("Week start date")
    goal = prompt_required_text("Goal")
    budget = prompt_float("Budget")

    confirmed = @prompt.yes?("Are you sure you want to add '#{name}' meal plan for #{user.name}?")

    if confirmed
      new_meal_plan = user.meal_plans.create(
        name: name,
        week_start: week_start,
        goal: goal,
        budget: budget
      )

      puts "Success! '#{new_meal_plan.name}' has been created."
    else
      puts "Adding meal plan canceled."
    end
  end

  def update_meal_plan(meal_plan)

    field = @prompt.select("Which field do you want to change?", %w[name week_start goal budget])

    new_value =
      case field
      when "name", "goal"
        prompt_required_text("Enter a new value for #{field}")
      when "week_start"
        prompt_date("Enter a new week start")
      when "budget"
        prompt_float("Enter a new value for #{field}")
      end

    if meal_plan.update(field.to_sym => new_value)
      puts "Success! Record updated in the database."
    else
      puts "Update failed: #{meal.errors.full_messages.join(', ')}"
    end
  end

  def delete_meal_plan(meal_plan)
    confirmed = @prompt.yes?("Are you absolutely sure you want to delete '#{meal_plan.name}'?")

    if confirmed
      meal_plan.destroy
      puts "Success! '#{meal_plan.name}' has been deleted."
    else
      puts "Deletion canceled."
    end
  end
end
