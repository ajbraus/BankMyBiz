class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    @trending_tags = Tag.first(30)
    if current_user.bank?
      @posts = Post.where(bank: false).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
      @recommended_users = User.where(bank: false).first(3)
    else
      @posts = Post.where(bank: true).order('created_at desc').paginate(:page => params[:page], :per_page => 20)
      @recommended_users = User.where(bank: true).first(3)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @mocs = Post.first(5)
    @post.create_activity :show, owner: current_user

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
