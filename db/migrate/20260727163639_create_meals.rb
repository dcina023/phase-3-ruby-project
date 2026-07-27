class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.string :meal_type
      t.integer :prep_time
      t.float :estimated_cost
      t.integer :calories
      t.boolean :prepared, default: false, null: false
      t.boolean :favorite, default: false, null: false
      t.bigint :meal_plan_id, null: false
      
      t.timestamps
    end
  end
end
