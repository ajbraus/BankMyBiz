User.where(bank: true).each do |u|
  p u.first_name + '      ' + u.last_name + '      ' + u.email
end

User.where(bank: false).each do |u|
  p u.first_name + '      ' + u.last_name + '      ' + u.email
end

User.all.each do |u|
  p u.first_name + '      ' + u.last_name + '      ' + u.email
end


