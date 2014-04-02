# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.bankmybiz.com"
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/sitemap-generator/"

SitemapGenerator::Sitemap.create do
  #CORE
  add '/how-it-works'
  add '/testimonials'
  add '/terms'
  add '/privacy'
  add '/about-us'
  add '/team'

  #PRODUCTS
  add '/term_loan' 
  add '/line_of_credit' 
  add '/sba_loan' 
  add '/factoring' 
  add '/grants' 
  add '/revenue_based' 
  add '/asset_based_financing' 
  add '/private_equity' 
  add '/community_development' 
  add '/angel_investment' 
  add '/venture_capital' 
  add '/crowd_funding_for_rewards' 
  add '/crowd_funding_for_equity' 
  add '/merchant_cash_advance' 
  add '/cash_advance_financing' 

  #ALL QUESTIONS
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
