class Api::V1::CommentsController < ApplicationController
  before_filter :authenticate_user_from_token!
  
  def vote_up
    begin
      current_user.vote_exclusively_for(@comment = Comment.find(params[:id]))
      @user = @comment.commentable.user
      @user.update_attributes(cred_count: @user.cred_count + 1)
      render nothing: true
    rescue ActiveRecord::RecordInvalid
      return render :status => :unprocessable_entity,
             :json => { success: false, :error => "There was a problem registering your vote." }
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@comment = Comment.find(params[:id]))
      
      @user = @comment.commentable.user
      @user.update_attributes(cred_count: @user.cred_count - 1)
      
      render nothing: true
    rescue ActiveRecord::RecordInvalid
      return render :status => :unprocessable_entity,
             :json => { success: false, :error => "There was a problem registering your vote." }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.new(params[:comment])

    if @comment.save
      @comment_users = (@comment.commentable.comments.map{ |c| c.user } + [@comment.commentable.user]).uniq
      @comment_users.each do |u|
        unless u == current_user
          Notifier.delay.new_comment(u, @comment)
        end
      end

    else
      
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

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
