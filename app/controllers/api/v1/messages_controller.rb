class Api::V1::MessagesController < ApplicationController
  before_filter :authenticate_user_from_token!

  def index
    @messages = current_user.messages.order('created_at desc')
    @sent_messages = current_user.sent_messages.order('created_at desc')

    render 'api/messages/index'
  end

  def show
    @message = Message.find(params[:id])
    if @message.sender == current_user
      other_user = @message.receiver
    else
      other_user = @message.sender
    end
    @messages = Message.where("(sender_id = :current_user_id OR sender_id = :other_user_id) AND (receiver_id = :current_user_id OR receiver_id = :other_user_id)", current_user_id: current_user.id, other_user_id: other_user.id).order('created_at DESC')

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