class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def vote_up
    begin
      current_user.vote_exclusively_for(@post = Post.find(params[:id]))
      @post.create_activity :voted_up, owner: current_user
      redirect_to :back
    rescue ActiveRecord::RecordInvalid
      redirect_to :back
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@post = Post.find(params[:id]))
      @post.create_activity :voted_down, owner: current_user
      redirect_to :back
    rescue ActiveRecord::RecordInvalid
      redirect_to :back
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    if params[:oofta] == 'true'
      flash.now[:warning] = "We're sorry, an error occured."
    end

    is_bank = !current_user.bank?
    if params[:search].present?
      #@posts = Post.search(params[:search], with: { bank: is_bank }, :page => params[:page], :per_page => 20)
      @posts = Post.search(params[:search], :page => params[:page], :per_page => 14)
    else
      #@posts = Post.where(bank: is_bank).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
      @posts = Post.order('created_at desc').paginate(:page => params[:page], :per_page => 14)
    end
    
    @new_post = Post.new
    @recent_messages = current_user.messages.first(3)
    @following_users = current_user.followed_users

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @posts }
    end    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    
    if user_signed_in?
      is_bank = !current_user.bank?
      @new_post = Post.new
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @user = current_user
    @post = @user.posts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @user = current_user
    @post = @user.posts.build(params[:post])
    if @user.bank?
      @post.bank = true
    else
      @post.bank = false
    end

    respond_to do |format|
      if @post.save
        @post.create_activity :create, owner: current_user
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { redirect_to :back }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to root_path, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
