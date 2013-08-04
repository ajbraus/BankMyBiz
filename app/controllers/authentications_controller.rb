class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    access_token = request.env["omniauth.auth"]
    @user = find_for_oauth(access_token)
    if @user.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => access_token.provider
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to :back, notice: 'There was an error with Facebook. Check your Facebook account status.'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  private

  def find_for_oauth(access_token)
    uid = access_token.uid
    email = access_token.info.email

    auth = Authentication.find_by_uid(uid.to_s)
    if auth.present?
      auth.update_attributes(uid: auth.uid)
      user = auth.user
      user.update_attributes(:linked_in_url => auth.info.urls.public_profile, 
                             :pic_url => access_token.info.image, 
                             :location => access_token.info.location)
      return user
    end
    
    user = User.find_by_email(email)
    if user.present?
      provider = access_token.provider
      authentication = user.authentications.build(:provider => provider)
      user.authentications << authentication
      user.update_attributes(email: access_token.info.email, 
                             name: access_token.info.name, 
                             :linked_in_url => access_token.info.urls.public_profile, 
                             :pic_url => access_token.info.image, 
                             :location => access_token.info.location)
    else
      user = User.create(:email => access_token.info.email, 
                :name => access_token.info.name,
                :terms => true,
                :remember_me => true,
                :password => Devise.friendly_token[0,20],
                :linked_in_url => access_token.info.urls.public_profile,
                :pic_url => access_token.info.image, 
                :location => access_token.info.location
              )
    end
    return user
  end
end