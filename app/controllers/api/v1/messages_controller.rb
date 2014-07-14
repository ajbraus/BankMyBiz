class Api::V1::MessagesController < ApplicationController
  before_filter :authenticate_user_from_token!

  def index
    @messages = current_user.messages.order('created_at desc')
    @sent_messages = current_user.sent_messages.order('created_at desc')
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
    if @message.present?
      Notifier.delay.send_message(@message)
      render 'api/messages/create'
    end
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