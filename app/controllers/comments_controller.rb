class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_commentable, except:[:destroy]
  
  def vote_up
    begin
      current_user.vote_exclusively_for(@comment = Comment.find(params[:id]))

      @user = @comment.commentable.user
      @user.update_attributes(cred_count: @user.cred_count + 1)

      render nothing: true
    rescue ActiveRecord::RecordInvalid
      redirect_to root_path, notice: "There was an error submitting your vote"
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@comment = Comment.find(params[:id]))
      
      @user = @comment.commentable.user
      @user.update_attributes(cred_count: @user.cred_count - 1)
      
      render nothing: true
    rescue ActiveRecord::RecordInvalid
      redirect_to root_path, notice: "There was an error submitting your vote"
    end
  end

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @commentable.comments.new(params[:comment])

    if @commentable.class.name == "Post"
      @redirect = @commentable
    else
      @redirect = @commentable.post
    end
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        @comment_users = (@comment.commentable.comments.map{ |c| c.user } + [@comment.commentable.user]).uniq
        @comment_users.each do |u|
          unless u == current_user
            Notifier.delay.new_comment(u, @comment)
          end
        end
      
        format.html { redirect_to @redirect, notice: "Comment created successfully" }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @commentable, notice: "There was a problem creating your comment. Please try again."}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable }
      format.json { head :no_content }
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
