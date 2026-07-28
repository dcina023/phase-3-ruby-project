class User < ActiveRecord::Base
  has_many :meal_plans
  has_many :meals, through: :meal_plans

  def users_budget
    meal_plans.sum(:budget)
  end

  def favorite_meals
    meals.where(favorite: true)

    def meal_options
      meals.pluck(:id, :name)

    end
  end
end
