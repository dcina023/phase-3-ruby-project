class User < ActiveRecord::Base
  has_many :meal_plans
  has_many :meals, through: :meal_plans


  def total_budget
    meal_plans.sum(:budget)
  end

  def favorite_meals
    meals.where(favorite: true)
  end

  def meal_options
    meals.pluck(:id, :name)
  end
end
