class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :require_no_authentication, :only => [:create ]
  include Devise::Controllers::Helpers
  
  def create
    warden.authenticate(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    render 'api/sessions/create'
  end

  def destroy
    warden.authenticate(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    current_user.reset_authentication_token!
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end
end