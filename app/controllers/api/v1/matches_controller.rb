class Api::V1::MatchesController < ApplicationController
  #before_filter :authenticate_user!
  
  def index
    @matches = User.find(4).matched_users
    #@matches = current_user.matched_users
    render 'api/matches/index'
  end

  def create
    3.times do 
      @user = current_user.select_new_match
      current_user.matched_users << @user
    end
    render 'api/matches/index'
  end

  def destroy
    @match = current_user.matches.find_by_match_id(params[:id])
    @match.destroy
    render 'api/matches/index'
  end
end