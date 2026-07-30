class MealPlan < ActiveRecord::Base
  belongs_to :user
  has_many :meals

  def total_estimated_cost
    meals.sum(:estimated_cost).to_f
  end

  def remaining_budget
    budget.to_f - total_estimated_cost
  end

  def within_budget?(estimated_cost)
    remaining_budget >= estimated_cost.to_f
  end

  def can_update_meal_cost?(meal, new_cost)
    adjusted_total = total_estimated_cost - meal.estimated_cost.to_f + new_cost.to_f
    adjusted_total <= budget.to_f
  end
end
