class SitemapsController < ApplicationController
  respond_to :xml
  caches_page :show

  def show
    @posts = Post.all
    @other_routes = ['/term-loan',
                     '/line-of-credit',
                     '/sba-loan',
                     '/factoring',
                     '/grants',
                     '/revenue-based',
                     '/asset-based-financing',
                     '/private-equity',
                     '/community-development-fund',
                     '/angel-investment',
                     '/venture-capital',
                     '/crowd-funding-for-rewards',
                     '/crowd-funding-for-equity',
                     '/merchant-cash-advance',
                     '/cash-advance-financing',
                     '/deposits',
                     '/credit-cards',
                     '/equipment-loan',
                     '/testimonials',
                     '/terms',
                     '/privacy',
                     '/about-us',
                     '/team',
                     '/advice']
    respond_to do |format|
     format.xml
    end
  end
end