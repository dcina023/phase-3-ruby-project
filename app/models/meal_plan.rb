class MealPlan < ActiveRecord::Base
  belongs_to :user
  has_many :meals

  def total_estimated_cost
    meals.sum(:estimated_cost)
  end

  def remaining_budget
    budget - total_estimated_cost
  end
end
