namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User, Post, Comment, Tag, Message, Authentication].each(&:delete_all)
    
    User.populate 20 do |user|
      user.name    = Faker::Name.name
      user.email   = Faker::Internet.email
      user.encrypted_password = "password"
      user.bio = ""
      user.bank = [true,false]
      user.confirmed_at = [Time.now, nil]
    end
    User.create(name:"Adam J Braus", email:"ajbraus@gmail.com", password:"password", bank: false, confirmed_at: Time.now)
    User.create(name:"Test Bank", email:"test@bank.com", password:"password", bank: true, confirmed_at: Time.now)

    User.all.each do |user|
      Post.populate 10..30 do |post|
        post.content = Populator.words(7..18).capitalize
        post.user_id = user.id
        post.created_at = 4.months.ago..Time.now
        Comment.populate 0..5 do |comment|
          comment.commentable_type = "Post"
          comment.commentable_id = post.id
          comment.content = Populator.words(3..14)
          comment.user_id = User.all.sample
        end
        Message.populate 1..6 do |message|
          message.subject = Populator.words(7..18).titleize
          message.body = Populator.words(50..120)
          message.sender_id = user.id
          message.receiver_id = user.id   #TODO - stop messaging yourself
          message.is_read = [true,false]
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