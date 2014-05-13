class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.set_products

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if @user.matched_users.empty? && @user.finished_profile?
          @user.subscriptions.create(plan_id: 0, expires_on: Date.today + 10.days, price_in_cents: 0)
          @user.set_initial_matches
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