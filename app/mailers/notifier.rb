class Notifier < ActionMailer::Base
  include UsersHelper
  include ActionView::Helpers::AssetTagHelper  
  layout 'email' # use email.(html|text).erb as the layout for emails
  default from: "BankmyBiz.com team@bankmybiz.com"

  def request_confirmation(user)
    @user = user
    mail to: "ajbraus@gmail.com, michaelantonadam@me.com", subject: "New User to Confirm or Reject"
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

  def new_comment(comment)
    @comment = comment
    @commenter = @comment.user
    @post = @comment.post
    @user = @post.user
    mail to: @user.email, subject: "New Comment on #{@post.title}"
  end
end
