class Api::V1::MessagesController < ApplicationController
  before_filter :authenticate_user_from_token!

  def index
    @messages = User.find(4).messages.paginate(:page => params[:page], :per_page => 15)
    @sent_messages = User.find(4).sent_messages.paginate(:page => params[:page], :per_page => 15)
    render 'api/messages/index'
  end

  def show
    @message = Message.find(params[:id])
    render 'api/messages/show'
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.create(params[:message])
    render 'api/messages/create'
  end

  def edit
    Message.find(params[:id])
    render 'api/messages/edit'
  end

  def update
    @message = Message.find(params[:id])
    @message.update_attributes(params[:message])
    render 'api/messages/show'
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
  end
end