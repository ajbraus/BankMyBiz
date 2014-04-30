class ProductsController < ApplicationController
  def show
  end

  # Traditional 
  def deposits
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def credit_cards
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def term_loan
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def line_of_credit
    @product = Product.find_by_name("Line of Credit")
  end
  def sba_loan #DONE
    @product = Product.find_by_name("SBA Loan")
  end

  # Non-traditional 
  def factoring
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def microloans
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def equipment_loan
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def revenue_based
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def asset_based_loan
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def private_equity
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def community_development_fund
    @product = Product.find_by_name("Community Development Fund")
  end
  def merchant_cash_advance
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def cash_advance
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def grants
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def crowd_funding_for_rewards
    @product = Product.find_by_name("Crowd Funding for Rewards")
  end

  # Equity
  def crowd_funding_for_equity
    @product = Product.find_by_name("Crowd Funding for Equity")
  end
  def angel_investment
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
  def venture_capital
    @product = Product.find_by_name(params[:action].underscore.titlecase)
  end
end
