class Notifier < ActionMailer::Base
  add_template_helper(UsersHelper)
  include UsersHelper
  include ActionView::Helpers::AssetTagHelper  
  layout 'email' # use email.(html|text).erb as the layout for emails
  default from: "Bankmybiz"

  # def new_subscription(user)
  #   @user = user
  #   mail to: @user.email, subject: "#{post.user.first_name_with_last_initial} just asked about #{@tag.name}. Give them some expert advice."
  # end

  def tag_follower_update(user, tag, post)
    @user = user
    @tag = tag
    @post = post
    mail to: @user.email, subject: "#{post.user.first_name_with_last_initial} just asked about #{@tag.name}. Give them some expert advice."
  end

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
    mail to: @user.email, subject: "Welcome to bankmybiz.com"
  end

  def send_message(message)
    @message = message
    @user = @message.receiver
    @sender = @message.sender
    mail to: @user.email, subject: "Message from #{@sender.first_name}"
  end

  def new_answer(user, answer)
    @user = user
    @answer = answer
    mail to: @user.email, subject: "#{answer.user.first_name_with_last_initial} Gave you Advice on Bankmybiz"
  end

  def new_comment(user, comment)
    @comment = comment
    @commenter = @comment.user
    @post = @comment.commentable
    @user = user
    mail to: @user.email, subject: "New comment on a post by #{@post.user.first_name_with_last_initial}"
  end

  def new_follower(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email, subject: "You have a new follower"
  end

  def new_match(user, match)
    @user = user
    @match = match
    mail to: @user.email, subject: "You Matched with #{@user.first_name_with_last_initial} with #{@user.org_name}"
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

    mail to: @user.email, subject: "You've been invited to Bank on Relationships"
  end

  def invitation_accepted(inviter, invitee)
    @user = inviter
    @invitee = invitee

    mail to: @user.email, subject: "#{@invitee.name} accepted your invitation."
  end
end
