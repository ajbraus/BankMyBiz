class TagsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tags = Tag.order(:name).where("lower(name) like ?", "%#{params[:term].downcase}%").first(10)

    render 'tags/index'
  end

  def create
    @tag = Tag.find_by_name(params[:tag][:name])
    if @tag.present?
      if !@tag.in?(current_user.tags)
        current_user.tags << @tag
        
        respond_to do |format|
          format.html
          format.js
        end
      else
        redirect_to root_path, notice: "You Already Follow that Tag"
      end
    else
      redirect_to root_path, notice: "No Tag of that Name Exists"
    end
  end
end