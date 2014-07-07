class Api::V1::PostsController < ApplicationController
  before_filter :authenticate_user_from_token!
  
  def index # GET (plural/array)
    @posts = Post.paginate(page: params[:page], per_page: 10, order: "created_at desc")
    render 'api/posts/index'
  end

  def show #GET (singular/object)
    @post = Post.find(params[:id])
    render 'api/posts/show'
  end

  def create #POST
    current_user.posts.create(params[:post])
    render 'api/posts/create'
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