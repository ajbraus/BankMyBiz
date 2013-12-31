class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  # before_filter :check_password_present

  # def check_password_present
  #   if user_signed_in?
  #     if current_user.password.blank?
  #       edit_password_path(current_user)
  #     end
  #   end
  # end

  protect_from_forgery
end
