class Api::V1::PostsController < ApplicationController
  #before_filter :authenticate_user!
  
  def index
    @posts = Post.paginate(page: params[:page], per_page: 10, order: "created_at desc")
    render 'api/posts/index'
  end

  def show
    @post = Post.find(params[:id])
    render 'api/posts/show'
  end

  def new
    @post = Post.new
  end

  def create
    current_user.posts.create(params[:post])
    render 'api/posts/create'
  end

  def edit
    Post.find(params[:id])
    render 'api/posts/edit'
  end

  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    render 'api/posts/show'
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  end
end