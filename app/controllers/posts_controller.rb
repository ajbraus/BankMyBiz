class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    if params[:search].present?
      if user_signed_in?
        @posts_by_state = Post.search(params[:search], with: { state: current_user.state }, :page => params[:page], :per_page => 10)
      end
      @posts = Post.search(params[:search], :page => params[:page], :per_page => 10)
      @posts_by_activity = Post.search(params[:search], order: 'last_touched asc', :page => params[:page], :per_page => 10)
      #@posts_by_followers = @mocs.sort_by { |m| m.followers.count }
    else 
      if user_signed_in?
        @posts_by_state = Post.where(state: current_user.state).order('created_at desc').paginate(:page => params[:page], :per_page => 10)
      end
      @posts = Post.order('created_at desc').paginate(:page => params[:page], :per_page => 10)
      @posts_by_activity = Post.order( "last_touched asc" ).paginate(:page => params[:page], :per_page => 10)
      #@posts_by_followers = Post.sort_by { |m| m.followers.count }
    end
    @trending_mocs = Post.first(3)
    @trending_tags = Tag.first(30)

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
