def add_5
  return num + 5
end

def get_time
  new_time = add_5('3')
  return "The time is #{new_time}"
end

puts get_time
