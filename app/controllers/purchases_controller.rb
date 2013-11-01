class PurchasesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @purchase = @user.purchases.new
    @first_three_matches = current_user.potential_matches.first(3)
  end

  def create
    @purchase = current_user.purchases.new(params[:purchase])

    if @purchase.save_with_payment
      redirect_to root_path, :notice => "You Successfully Purchased 3 New Matches"
    else
      render :new
    end
  end
end