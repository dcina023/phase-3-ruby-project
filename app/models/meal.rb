class Meal < ActiveRecord::Base
  belongs_to :meal_plan

  validates :name, presence: true, uniqueness: true
  validates :estimated_cost, numericality: true
end
