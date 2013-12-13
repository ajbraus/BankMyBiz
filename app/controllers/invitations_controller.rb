class InvitationsController < Devise::InvitationsController
  def create
    params[:user][:email].split(',').each do |email|    
      User.invite!({ email: email }, current_user) do |u|
        u.skip_invitation = true
      end
      
      Notifier.delay.invitation(User.find_by_email(email), current_user, params[:body])
      
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end