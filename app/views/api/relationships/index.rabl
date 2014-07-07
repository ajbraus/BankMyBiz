collection @followed_users, :root => "followed_users"
extends "api/users/mini_show"

collection @followers, :root => "followers"
extends "api/users/mini_show"
