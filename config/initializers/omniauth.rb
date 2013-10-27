Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV["LINKEDIN_API_KEY"], ENV["LINKEDIN_SECRET_KEY"], :scope => 'r_basicprofile r_emailaddress', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"] #"connections"
end