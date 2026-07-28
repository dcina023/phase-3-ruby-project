def list_users
  User.all.each do |user|
    puts "#{user.id}. #{user.name}"
  end
end

def add_new_user
  print "Add a new user:"
  name = gets.chomp

  confirmed = @prompt.yes?("Are you sure you want to add '#{name}'?")

  if confirmed
    user = User.create(name: name)
    puts "Success! '#{user.name}' has been created."
  else
    puts "Adding user canceled."
  end
end

def select_user
  print "Enter a user's name: "
  user_name = gets.chomp

  user = User.includes(meal_plans: :meals).find_by(name: user_name)

  if user
    puts "\nSelected user: #{user.name} (ID: #{user.id})"
    user
  else
    puts "User not found."
    nil
  end
end
