class InvitationsController < Devise::InvitationsController
  def create

    params[:user][:email].split(',').each do |email|    
      User.invite!(email: email) do |u|
        u.skip_invitation = true
        Notifier.invitation(u, current_user, params[:body]).deliver
        respond_to do |format|
          format.html
          format.js
        end
        return
      end
    end

    super
  end
end