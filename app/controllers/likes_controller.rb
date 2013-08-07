class LikesController < ApplicationController
  before_filter :authenticate_user!

  def create
    binding.pry
    @likeable = find_likeable
    @like = @likeable.likes.build(params[:like])
    @like.user = current_user

    respond_to do |format|
      if @like.save
        format.html { redirect_to root_path, notice: "Like Successfully Created"}
        format.js
        format.json { head :no_content }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to likes_url }
      format.json { head :no_content }
    end
  end

  private

  def find_likeable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end