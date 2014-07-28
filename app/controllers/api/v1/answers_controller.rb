class Api::V1::AnswersController < ApplicationController
  before_filter :authenticate_user_from_token!
  
  def vote_up
    begin
      current_user.vote_exclusively_for(@answer = Answer.find(params[:id]))
      @answer.user.update_attributes(cred_count: @user.cred_count + 1)
      render nothing: true
    rescue ActiveRecord::RecordInvalid
      return render :status => :unprocessable_entity,
             :json => { success: false, :error => "There was a problem registering your vote." }
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@answer = Answer.find(params[:id]))
      @answer.user.update_attributes(cred_count: @user.cred_count - 1)
      render nothing: true
    rescue ActiveRecord::RecordInvalid
      return render :status => :unprocessable_entity,
             :json => { success: false, :error => "There was a problem registering your vote." }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @answer = current_user.answers.new(params[:answer])

    if @answer.save
      Notifier.delay.new_answer(@post.user, @answer)
      if @post.user != current_user
        current_user.update_attributes(cred_count: current_user.cred_count + 10)
      end

    else
      
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:comment])
        format.html { redirect_to @answer }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answerable = @answer
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to @answerable }
      format.json { head :no_content }
    end
  end
end
