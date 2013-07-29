namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User, Post, Comment, Tag].each(&:delete_all)
    
    User.populate 20 do |user|
      user.name    = Faker::Name.name
      user.email   = Faker::Internet.email
      user.encrypted_password = "password"
    end
    User.create(name:"Adam J Braus", email:"ajbraus@gmail.com", password:"password")
    User.all.each do |user|
      Post.populate 10..30 do |post|
        post.content = Populator.words(7..18).titleize
        post.user_id = user.id
        post.created_at = 4.months.ago..Time.now
        post.last_touched = 4.months.ago..Time.now
        Comment.populate 3..30 do |comment|
          comment.commentable_type = "Post"
          comment.commentable_id = post.id
          comment.content = Populator.words(3..14)
        end
      end
    end
    Post.all.each do |post|
      5.times { post.tags << Tag.create(:name => Populator.words(1)) } 
    end
    
    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }

    #rake ts:index
    
    # Person.populate 100 do |person|
    #   person.name    = Faker::Name.name
    #   person.company = Faker::Company.name
    #   person.email   = Faker::Internet.email
    #   person.phone   = Faker::PhoneNumber.phone_number
    #   person.street  = Faker::Address.street_address
    #   person.city    = Faker::Address.city
    #   person.state   = Faker::Address.us_state_abbr
    #   person.zip     = Faker::Address.zip_code
    # end
  end
end