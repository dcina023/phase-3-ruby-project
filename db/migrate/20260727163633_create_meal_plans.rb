class CreateMealPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_plans do |t|
      t.string :name, null: false
      t.date :week_start
      t.string :goal
      t.float :budget
      t.bigint :user_id, null: false
     
      t.timestamps
    end
  end
end
