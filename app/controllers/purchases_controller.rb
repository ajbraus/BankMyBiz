class PurchasesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
    @purchase = @user.purchases.new
    @first_three_matches = current_user.potential_matches.first(3)
    if current_user.stripe_customer_id.present?
      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id) 
      @cards = Stripe::Customer.retrieve(current_user.stripe_customer_id).cards.all
    end
  end

  def create
    @purchase = current_user.purchases.new(params[:purchase])    

    if @purchase.valid? && params[:stripe_card_id].present?
      if current_user.stripe_customer_id.present?
        begin
          customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        rescue
          redirect_to new_purchase_path, notice: "There was a problem with your purchase. Please try again."
          return
        end
      else
        begin
          customer = Stripe::Customer.create(description:current_user.email, card: params[:stripe_card_id])
        rescue
          redirect_to new_purchase_path, notice: "There was a problem with your purchase. Please try again."
          return
        end
        current_user.update_attributes(stripe_customer_id: customer.id)
      end

      begin
        card = customer.cards.retrieve(params[:stripe_card_id]) 
      rescue
        if card.blank?
          begin
            card = customer.cards.create(:card => params[:stripe_card_id])
          rescue
            redirect_to new_purchase_path, notice: "There was a problem with your purchase. Please try again."
            return
          end
        end
      end

      begin
        charge = Stripe::Charge.create(
          :amount => ((params[:purchase][:price].to_f)*100).to_i,
          :currency => "usd",
          :customer => customer["id"],
          :card => card["id"], # obtained with Stripe.js
          :description => "Match Purchase for #{current_user.email}"
        )
      rescue
        redirect_to new_purchase_path, notice: "There was a problem with your purchase. Please try again."
        return
      end
      current_user.matched_users << current_user.potential_matches.first(3)
      @purchase.save
      redirect_to matches_path, :notice => "You Successfully Purchased 3 New Matches"
      return
    else
      redirect_to new_purchase_path, notice: "There was a problem with your purchase. Please try again."
    end
  end
end