class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]

  def vote_up
    begin
      current_user.vote_exclusively_for(@post = Post.find(params[:id]))

      @user = @post.user
      @user.update_attributes(cred_count: @user.cred_count + 1)

      render nothing: true
      
    rescue ActiveRecord::RecordInvalid
      redirect_to root_path, notice: "There was an error submitting your vote"
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@post = Post.find(params[:id]))
      
      @user = @post.user
      @user.update_attributes(cred_count: @user.cred_count - 1)

    render nothing: true

    rescue ActiveRecord::RecordInvalid
      redirect_to root_path, notice: "There was an error submitting your vote"
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    if params[:oofta] == 'true'
      flash.now[:warning] = "We're sorry, an error occured."
    end

    if params[:search].present?
      @posts = Post.search(params[:search], :page => params[:page], :per_page => 10, order: 'created_at DESC')
      @active = Post.search(params[:search], :page => params[:page], :per_page => 10, order: 'last_touched_at DESC')
    else
      @posts = Post.order('created_at desc').paginate(:page => params[:page], :per_page => 10)
      @active = Post.order('last_touched_at desc').paginate(:page => params[:page], :per_page => 10)  
    end
    @unanswered = @posts.select { |p| p.answers.none? }.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @posts }
    end    
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @post.update_attributes(impressions_count: @post.impressions_count += 1)
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
    @post = current_user.posts.new

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
    @post = current_user.posts.build(params[:post])
    @post.last_touched_at = Time.now

    respond_to do |format|
      if @post.save
        current_user.update_attributes(cred_count: current_user.cred_count + 10)
        current_user.followers.each do |f|
          Notifier.delay.new_post(f, @post)
        end
        @post.delay.send_update_to_tag_followers(current_user)
        current_user.tags << @post.tags

        format.html { redirect_to root_path }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { redirect_to :back, notice: 'There was a problem, please try again' }
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
        format.html { redirect_to root_path }
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
    @user = @post.user
    @post.destroy

    @user.update_attributes(cred_count: current_user.cred_count - 10)

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
