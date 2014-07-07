class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def authenticate_user_from_token!
    @current_user = User.find_by_auth_token(params[:auth_token])
    if current_user.blank?
      return render status: 401,
                    json: { success: false, 
                            error: "Authentication Token Invalid or Missing." }
    end
  end
end
