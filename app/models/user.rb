class User < ActiveRecord::Base
  has_many :meal_plans
  has_many :meals, through: :meal_plans

  def create_meal_plan(attributes)
    meal_plans.create(attributes)
  end

  def users_budget
    meal_plans.sum(:budget)
  end

  def favorite_meal
    meals.where(favorite: true)
  end

  def select_individual_meal
    meals.pluck(:id, :name)
  end

  def find_meal(input)
    meals.find_by(id: input) || meals.find_by(name: input)
  end

  def add_favorite_meal(input)
    meal = find_meal(input)
    meal.update(favorite: true)
    meal
  end
end
