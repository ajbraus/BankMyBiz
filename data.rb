User.where(bank: true).map { |u| u.org_name }.uniq

Industry.all.each do |i|
  p i.description
  p i.users.where(bank:true).count
  p i.users.where(bank:false).count
end

engagements = 0
Post.all.each do |p|
  if p.answers.any? || p.comments.any?
    engagements += 1
  end
end
p engagements

Post.all.count
