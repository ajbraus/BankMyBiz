class Notifier < ActionMailer::Base
  include UsersHelper
  include ActionView::Helpers::AssetTagHelper  
  layout 'email' # use email.(html|text).erb as the layout for emails
  default from: "Bank my Biz Team BankmyBiz@gmail.com"

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Mocs for Docs"
  end

  def send_message(message)
    @message = message
    @receiver = @message.receiver
    @sender = @message.sender
    mail to: @receiver.email, subject: "BankmyBiz Message from #{@sender.first_name}"
  end
end
