class UsersController < ApplicationController
  before_filter :authenticate_user!
  impressionist :actions=>[:show]

  def show
    @user = User.find(params[:id])
    if user_signed_in?
      is_bank = !current_user.bank?
      if @user == current_user
        @post = Post.new
      else
        @user.create_activity :show, owner: current_user
      end
    end
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 7)
    @activities = PublicActivity::Activity.where(owner_id: @user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 7) #.where(owner_id: current_user.friend_ids, owner_type: "User")
    @matches = current_user.todays_matches
    @peers = current_user.todays_peers
    @trending_tags = Tag.first(10)
  end

  def index
    if current_user.admin?
      @unconfirmed_users = User.where("confirmed_at IS NULL").paginate(:page => params[:page], :per_page => 20)
      @confirmed_users = User.where("confirmed_at IS NOT NULL").paginate(:page => params[:page], :per_page => 20)
      @rejected_users = User.where("rejected_at IS NOT NULL").paginate(:page => params[:page], :per_page => 20)
    else 
      redirect_to root_path, notice: "Oops, here you go!"
    end
  end

  def confirm
    @user = User.find(params[:user_id])
    @user.confirmed_at = Time.now
    @user.rejected_at = nil
    @user.save

    respond_to do |format|
      format.html { redirect_to users_path, notice:"User successufly confirmed" }
      format.js
      format.json { render json: @user }
    end  
  end

  def reject
    @user = User.find(params[:user_id])
    @user.rejected_at = Time.now
    @user.confirmed_at = nil
    @user.save

    respond_to do |format|
      format.html { redirect_to users_path, notice:"User successufly rejected" }
      format.js
      format.json { render json: @user }
    end  
  end

  def set_bank
    @user = User.find(params[:id])
    @user.update_attributes(bank: true)
    @user.locations << Location.first

    respond_to do |format|
      format.html { redirect_to edit_profile_path(@user) }
      format.js
      format.json { render json: @user }
    end  
  end

  def set_business
    @user = User.find(params[:id])
    @user.update_attributes(bank: false)

    respond_to do |format|
      format.html { redirect_to edit_profile_path(@user) }
      format.js
      format.json { render json: @user }
    end  
  end
end