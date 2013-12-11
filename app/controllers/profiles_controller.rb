class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if @user.matched_users.empty? && @user.finished_profile?
          @user.set_matches
          @user.set_peers
          @user.delay.add_to_mc_lists
        end
        format.html { redirect_to @user }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end