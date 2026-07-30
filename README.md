# Meal Prep Tracker

Meal Prep Tracker is a Ruby CLI application built with ActiveRecord and SQLite3. The app allows users to create and manage meal plans, add meals to meal plans, update meal information, delete records, and view meal plan budget summaries from the terminal.

## Requirements

Before running the application, make sure you have:

- Ruby installed
- Bundler installed
- SQLite3 installed

## Installation

Clone the repository from GitHub:

    git clone <your-repo-url>

Move into the project directory:

    cd <repo-folder-name>

Install the project dependencies:

    bundle install

## Database Setup

Create the database:

    bundle exec rake db:create

Run the migrations to create the database tables:

    bundle exec rake db:migrate

Seed the database with sample data:

    bundle exec rake seed

## Running the Application

Start the CLI from the project root:

    ruby cli/cli.rb

## Useful Development Commands

Open a Pry console with the application environment loaded:

    bundle exec rake console

Create a new migration:

    bundle exec rake db:new_migration name=migration_name

Example:

    bundle exec rake db:new_migration name=create_users

## Main Features

The CLI supports:

- Viewing users
- Selecting a user
- Adding and deleting users
- Viewing a user’s meal plans and meals
- Adding, updating, and deleting meal plans
- Adding, updating, and deleting meals
- Viewing meal plan budget summaries
- Preventing meals from exceeding a meal plan’s budget