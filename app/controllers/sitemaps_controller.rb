class SitemapsController < ApplicationController
  respond_to :xml
  caches_page :show

  def show
    @posts = Post.all
    @other_routes = ['/term_loan',
                     '/line_of_credit',
                     '/sba_loan',
                     '/factoring',
                     '/grants',
                     '/revenue_based',
                     '/asset_based_financing',
                     '/private_equity',
                     '/community_development_fund',
                     '/angel_investment',
                     '/venture_capital',
                     '/crowd_funding_for_rewards',
                     '/crowd_funding_for_equity',
                     '/merchant_cash_advance',
                     '/cash_advance_financing',
                     '/how-it-works',
                     '/testimonials',
                     '/terms',
                     '/privacy',
                     '/about-us',
                     '/team',
                     '/advice'
                 ]
    respond_to do |format|
     format.xml
    end
  end
end