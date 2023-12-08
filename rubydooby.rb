a = "west Virginia"

b = a.split()

cap = []
b.each do |word|
  cap << word.capitalize
end

final = cap.join(" ")