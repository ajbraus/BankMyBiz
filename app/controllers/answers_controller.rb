class AnswersController < ApplicationController
  before_filter :authenticate_user!

  def vote_up
    begin
      current_user.vote_exclusively_for(@answer = Answer.find(params[:id]))
      @answer.create_activity :voted_up, owner: current_user

      @user = @answer.user
      @user.update_attributes(cred_count: @user.cred_count + 1)

      redirect_to :back
    rescue ActiveRecord::RecordInvalid
      redirect_to :back
    end
  end

  def vote_down
    begin
      current_user.vote_exclusively_against(@answer = Answer.find(params[:id]))
      @answer.create_activity :voted_down, owner: current_user

      @user = @answer.user
      @user.update_attributes(cred_count: @user.cred_count - 3)

      redirect_to :back
    rescue ActiveRecord::RecordInvalid
      redirect_to :back
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
    @post = @answer.post
  end

  # POST /answers
  # POST /answers.json
  def create
    @post = Post.find(params[:post_id])
    @answer = @post.answers.new(params[:answer])
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        if @answer.user != current_user
          current_user.update_attributes(cred_count: current_user.cred_count + 10)
        end
        format.html { redirect_to @post, notice: 'Answer was successfully created.' }
        format.json { render json: @answer, status: :created, location: @answer }
      else
        format.html { render action: "new" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.json
  def update
    @answer = Answer.find(params[:id])
    @post = @answer.post

    if params[:answer][:accepted] == "true"
      @post.answers.where(accepted: true).each { |a| a.update_attributes(accepted: false) } 
      @answer.user.update_attributes(cred_count: current_user.cred_count + 25) unless current_user == @answer.user
    elsif params[:answer][:accepted] == "false"
      @answer.user.update_attributes(cred_count: current_user.cred_count - 25)
    end

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to @post, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @post = @answer.post
    @user = @answer.user
    @answer.destroy

    @user.update_attributes(cred_count: current_user.cred_count - 10)

    respond_to do |format|
      format.html { redirect_to @post }
      format.json { head :no_content }
    end
  end
end
