# Meal Prep Tracker 

## Description: 

- Meal Prep Tracker is a Ruby backend application built with ActiveRecord that supports creating, updating, and deleting weekly meal plans, organizing meals within those plans, and managing meal data for individual users. 

## Models:
 
 - User
 - MealPlan
 - Meal

## Associations:

- A User has many MealPlans.
- A User has many Meals through MealPlans. 
- A MealPlan belongs to a User.
- A MealPlan has many Meals.
- A Meal belongs to a MealPlan.

## User Stories

- View existing users.
- View a user's meal plans.
- Create a new meal plan for a user.
- Update an existing meal plan.
- Delete a meal plan.
- Add meals to a meal plan.
- Update meal information.
- Remove meals from a meal plan.
- View all meals within a meal plan.