class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :require_no_authentication, :only => [:create]
  include Devise::Controllers::Helpers
  
  def create
    # params[:user] = params[:session]
    @user = User.where('lower(email) = ?', params[:email].downcase).first
    unless @user
      return render :status => :unprocessable_entity,
             :json => { success: false, :error => "No account exists with that email address." }
    end
    unless @user.valid_password?(params[:password])
      return render :status => :unprocessable_entity,
                    json: { success: false, :error => "The email or password you entered is incorrect." }
    end
    return render status: 200, json: { success: true, auth_token: @user.auth_token }
  end

  def destroy
    resource = warden.authenticate(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    resource.reset_authentication_token!
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end
end