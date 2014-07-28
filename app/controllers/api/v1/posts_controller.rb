class Api::V1::PostsController < ApplicationController
  before_filter :authenticate_user_from_token!

  def vote_up
    begin
      current_user.vote_exclusively_for(@post = Post.find(params[:id]))
      @post.user.update_attributes(cred_count: @user.cred_count + 1)
      render nothing: true
    rescue ActiveRecord::RecordInvalid
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@post = Post.find(params[:id]))
      @post.user.update_attributes(cred_count: @user.cred_count - 1)
      render nothing: true
    rescue ActiveRecord::RecordInvalid
    end
  end
  
  def index # GET (plural/array)
    @posts = Post.paginate(page: params[:page], per_page: 10, order: "created_at desc")
    render 'api/posts/index'
  end

  def show #GET (singular/object)
    @post = Post.find(params[:id])
    render 'api/posts/show'
  end

  def create #POST
    @post = current_user.posts.build(params[:post])
    @post.last_touched_at = Time.now

    if @post.save
      current_user.update_attributes(cred_count: current_user.cred_count + 10)
      current_user.followers.each do |f|
        Notifier.delay.new_post(f, @post)
      end
      @post.delay.send_update_to_tag_followers(current_user)
      current_user.tags << @post.tags

      return render status: 200, json: { success: true }
    else
      render :status => :unprocessable_entity,
                        json: { success: false, :errors => @post.errors }
    end
    
  end

  def update # PUT
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    render 'api/posts/show'
  end

  def destroy #DELETE
    @post = Post.find(params[:id])
    @post.destroy
  end
end