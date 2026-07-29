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
end
