class EmailUnsubscriptionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by_email(params[:email])
    @user.update_attributes(receive_match_messages: false)
    redirect_to root_path, notice: "You have been unsubscribed to match emails"
  end
end
