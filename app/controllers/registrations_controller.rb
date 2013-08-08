class RegistrationsController < Devise::RegistrationsController
  
  def add_avatar

  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if params[:user][:password].present?
      @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  protected

  def after_sign_up_path_for(resource)
    '/'
  end
end