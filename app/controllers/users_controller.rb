class UsersController < ApplicationController
  before_filter :authenticate_user!

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
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 7, order: 'created_at desc')
    @activities = PublicActivity::Activity.where(owner_id: @user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 5) #.where(owner_id: current_user.friend_ids, owner_type: "User")
  end

  def index
    if current_user.admin?
      @unconfirmed_users = User.where("confirmed_at IS NULL and rejected_at IS NULL").paginate(:page => params[:page], :per_page => 40, order: "created_at DESC")
      @invited_users = User.invitation_not_accepted.paginate(:page => params[:page], :per_page => 40, order: "created_at DESC")      
      @confirmed_users = User.where("confirmed_at IS NOT NULL").paginate(:page => params[:page], :per_page => 40, order: "confirmed_at DESC")      
      @rejected_users = User.where("rejected_at IS NOT NULL").paginate(:page => params[:page], :per_page => 40, order: "rejected_at DESC")
    else 
      redirect_to root_path, notice: "Oops, here you go!"
    end
  end

  def set_business
    @user = User.find(params[:id])
    @user.bank = false
    
    if @user.save
      redirect_to edit_profile_path(@user)
    else
      redirect_to :back, notice: "There was a problem. Try again"
    end
  end

  def set_bank
    @user = User.find(params[:id])
    @user.bank = true

    if @user.save
      redirect_to edit_profile_path(@user)
    else
      redirect_to :back, notice: "There was a problem. Try again"
    end
  end
end