class User < ActiveRecord::Base
  has_many :meal_plans
  has_many :meals, through: :meal_plans
end
