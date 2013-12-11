class Notifier < ActionMailer::Base
  add_template_helper(UsersHelper)
  include UsersHelper
  include ActionView::Helpers::AssetTagHelper  
  layout 'email' # use email.(html|text).erb as the layout for emails
  default from: "BankmyBiz Team - team@bankmybiz.com"

  def internal_new_user(user)
    @user = user
    mail to: "team@bankmybiz.com", subject: "New User to Confirm or Reject"
  end

  def confirmation_of_request(user)
    @user = user
    mail to: @user.email, subject: "Request received for access"
  end

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to BankmyBiz.com"
  end

  def send_message(message)
    @message = message
    @receiver = @message.receiver
    @sender = @message.sender
    mail to: @receiver.email, subject: "Message from #{@sender.first_name}"
  end

  def new_comment(user, comment)
    @comment = comment
    @commenter = @comment.user
    @post = @comment.commentable
    @user = user
    mail to: @user.email, subject: "New comment on a conversation"
  end

  def new_follower(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email, subject: "You have a new follower"
  end

  def new_match(user, match)
    @user = user
    @match = match
    mail to: @user.email, subject: "New #{@user.bank? ? "owner" : "lender"} match"
  end

  def profile_reminder(u)
    @user = u
    mail to: @user.email, subject: "Get matches by completing your profile"
  end

  def new_post(user, post)
    @user = user
    @post = post
    mail to: @user.email, subject: "#{@post.user.first_name_with_last_initial}'s New Post"
  end

  def invitation(user, inviter, body)
    @user = user
    @inviter = inviter
    @body = body

    mail to: @user.email, subject: "#{@user.name} invites you to bank on relationships"
  end

  def invitation_accepted(inviter, invitee)
    @inviter = user
    @invitee = invitee

    mail to: @inviter.email, subject: "#{@invitee.name} accepted your invitation."
  end
end
