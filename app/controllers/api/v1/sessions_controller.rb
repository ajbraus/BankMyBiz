class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :require_no_authentication, :only => [:create]
  include Devise::Controllers::Helpers
  
  def create
    resource = warden.authenticate(:scope => :user, :store => false, :recall => "#{controller_path}#failure")
    render :status => 200,
         :json => { :success => true,
                    :info => "Signed In",
                    :id => resource.id,
                    :auth_token => resource.auth_token,
                    :name => resource.name}
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