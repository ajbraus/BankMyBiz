class MatchesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @matches = current_user.matched_users.order('created_at DESC')
    @first_three_matches = current_user.potential_matches.first(3)
    @potential_matches_count = current_user.potential_matches.count
  end
end