class Main
  def prompt_required(prompt_text)
    loop do
      print "#{prompt_text}: "
      input = gets.chomp.strip

      throw(:back) if input.downcase == "back"
      return input unless input.empty?

      puts "Input cannot be blank."
    end
  end

  def prompt_required_text(prompt_text)
  loop do
    print "#{prompt_text} or type 'back': "
    input = gets.chomp.strip

    throw(:back) if input.downcase == "back"
    return input if input.match?(/[a-zA-Z]/)

    puts "Input cannot be blank and must include text."
  end
end

  def prompt_integer(prompt_text)
    loop do
      print "#{prompt_text}: "
      input = gets.chomp.strip

      throw(:back) if input.downcase == "back"
      return input.to_i if input.match?(/^\d+$/)

      puts "Invalid input. Please enter a whole number."
    end
  end

  def prompt_float(prompt_text)
    loop do
      print "#{prompt_text}: "
      input = gets.chomp.strip

      throw(:back) if input.downcase == "back"
      return input.to_f if input.match?(/^\d+(\.\d+)?$/)

      puts "Invalid input. Please enter a valid number."
    end
  end

  def prompt_boolean(prompt_text)
    @prompt.yes?(prompt_text)
  end

  def prompt_prep_time
    hours = prompt_integer("Prep hours")
    minutes = prompt_integer("Prep minutes")

    (hours * 60) + minutes
  end

  def format_prep_time(total_minutes)
    hours = total_minutes / 60
    minutes = total_minutes % 60

    if hours > 0
      "#{hours} hr #{minutes} min"
    else
      "#{minutes} min"
    end
  end

  def prompt_date(prompt_text)
    loop do
      print "#{prompt_text} (MM/DD/YYYY): "
      input = gets.chomp.strip

      throw(:back) if input.downcase == "back"
      return input if input.match?(%r{^\d{2}/\d{2}/\d{4}$})

      puts "Invalid date format. Please enter date as MM/DD/YYYY"
    end
  end
end
