base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url {
    xml.loc("http://bankmybiz.com")
    xml.changefreq("daily")
  }
  @other_routes.each do |other|
    xml.url {
      xml.loc("http://bankmybiz.com#{other}")
      xml.changefreq("monthly")
    }
  end
  @posts.each do |p|
    xml.url {
      xml.loc("http://bankmybiz.com/posts/#{p.id.to_s}")
      xml.changefreq("daily")
    }
  end
end