class Api::V1::PostsController < ApplicationController

  def index
    @posts = Post.paginate(:page => params[:page])
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
    Post.create(params[:post])
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