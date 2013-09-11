class Notifier < ActionMailer::Base
  include UsersHelper
  include ActionView::Helpers::AssetTagHelper  
  layout 'email' # use email.(html|text).erb as the layout for emails
  default from: "BankmyBiz.com team@bankmybiz.com"

  def internal_new_user(user)
    @user = user
    mail to: "team@bankmybiz.com", subject: "New User to Confirm or Reject"
  end

  def confirmation_of_request(user)
    @user = user
    mail to: @user.email, subject: "Request Received for BankmyBiz.com Access"
  end

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to BankmyBiz.com"
  end

  def send_message(message)
    @message = message
    @receiver = @message.receiver
    @sender = @message.sender
    mail to: @receiver.email, subject: "Message from #{@sender.first_name} - BankmyBiz.com"
  end

  def new_comment(user, comment)
    @comment = comment
    @commenter = @comment.user
    @post = @comment.post
    @user = user
    mail to: @user.email, subject: "New Comment on #{@post.title}"
  end

  def new_follower(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email, subject: "You have a new Follower on BankmyBiz.com"
  end
end
