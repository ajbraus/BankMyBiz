namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User, Post, Comment, Tag, Message, Authentication, Match, Peer, Relationship, Vote].each(&:delete_all)
    
    User.populate 50 do |user|
      user.name    = Faker::Name.name
      user.email   = Faker::Internet.email
      user.encrypted_password = "password"
      user.bio = Faker::Lorem.paragraph
      user.goals = Faker::Lorem.paragraph
      user.org_name = Populator.words(1..3).capitalize
      user.position = Populator.words(1..2).capitalize
      user.bank = [true,false]
      user.confirmed_at = [Time.now]
      user.handle = "twitter"
      user.status = "Actively Looking"
      user.hq_state = "WI"
      user.pic_url = "http://m.c.lnkd.licdn.com/mpr/mprx/0_ZPIPybiaZP0CyQzaVK4hyL6T4-EfyQLasN02yXkYFAY0_G-mqvRx-krK9sor0TXGMKdSP_s-SNno"
    end
    User.create(name:"Adam J Braus", email:"ajbraus@gmail.com", password:"password", bank: false, confirmed_at: Time.now)
    User.create(name:"Test Bank", email:"test@bank.com", password:"password", bank: true, confirmed_at: Time.now)

    User.all.each do |user|
      user.industries << Industry.first(2)
      user.locations << Location.first(2)
      if user.bank?
        num = 3
      else 
        num = 1
      end
      user.employee_sizes << EmployeeSize.first(num)
      user.business_types << BusinessType.first(num)
      user.ages << Age.first(num)
      user.revenue_sizes << RevenueSize.first(num)
      user.locations << Location.first(num)

      Post.populate 2..5 do |post|
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

    User.set_peers_and_matches
  end
end