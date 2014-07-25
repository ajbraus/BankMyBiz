object false

child @followers => :followers do 
  extends "api/users/mini_show"
end
 
child @followed_users => :followed_users do 
  extends "api/users/mini_show"
end

