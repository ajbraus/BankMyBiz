class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    access_token = request.env["omniauth.auth"]
    @user = find_for_oauth(access_token)
    if @user.present?
      if @user.confirmed?
        # flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => access_token.provider
        sign_in_and_redirect @user, :event => :authentication
      else
        Devise::Mailer.confirmation_instructions(@user).deliver
        redirect_to root_path, notice: "We have sent you an email to confirm your account. Thanks for joining!"
      end
    else
      redirect_to :back, error: 'There was an error with LinkedIn. Check your LinkedIn account status.'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    # flash[:success] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  private

  def find_for_oauth(access_token)
    # FIND AUTH BY UID
    uid = access_token.uid
    auth = Authentication.find_by_uid(uid.to_s)
    if auth.present?
      auth.update_attributes(uid: auth.uid, :profile_pic_url => access_token.info.image)
      user = auth.user
      user.update_attributes(:linked_in_url => access_token.info.urls.public_profile, 
                             :location => access_token.info.location)
      return user
    end
    # NO AUTH SO FIND USER BY EMAIL
    user = User.find_by_email(access_token.info.email)
    if user.present? 
      # IF USER PRESENT CREATE AUTH AND UPDATE USER
      provider = access_token.provider
      uid = access_token.uid
      authentication = user.authentications.build(provider: provider, uid: uid, :profile_pic_url => access_token.info.image)
      user.authentications << authentication
      user.update_attributes(email: access_token.info.email, 
                             name: access_token.info.name, 
                             :linked_in_url => access_token.info.urls.public_profile, 
                             :location => access_token.info.location)
    else
      #IF NO USER CREATE USER AND AUTH
      user = User.new(:email => access_token.info.email, 
                :name => access_token.info.name,
                :terms => true,
                :remember_me => true,
                :password => Devise.friendly_token[0,20],
                :linked_in_url => access_token.info.urls.public_profile,
                :location => access_token.info.location
              )
      user.skip_confirmation!
      if user.save
        provider = access_token.provider
        uid = access_token.uid
        authentication = user.authentications.create(provider: provider, uid: uid, profile_pic_url: access_token.info.image)
        user.authentications << authentication
      end
    end
    return user
  end
end