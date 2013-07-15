class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @profile = @user.profiles.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  def create
    @user = current_user
    @profile = @user.build_profile(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { redirect_to :back }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if current_user.profiles.any?
      @profile = current_user.profiles.first
    else
      @profile = current_user.profiles.build
    end
  end
  
  def update
    @profile = Post.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to root_path, notice: 'Profile was Successfully Updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end
end