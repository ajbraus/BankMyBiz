# file: app/controllers/api/v1/registrations_controller.rb
class Api::V1::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(params[:registration])
    resource.skip_confirmation!
    if resource.save
      sign_in(resource, :store => false)
      render :status => 200,
           :json => { :success => true,
                      :info => "Registered",
                      :id => current_user.id,
                      :auth_token => current_user.auth_token }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => resource.errors,
                        :data => {} }
    end
  end
end