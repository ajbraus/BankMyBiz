require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

CSV.open("danebuylocal.csv", "wb") do |csv|
  for i in 0..38
    num = (i * 20).to_s
    url = "http://www.danebuylocal.com/index.php?option=com_community&view=search&uuId=536a6dee0a5cf&params[servId]=5339&params[option]=com_community&params[view]=search&params[Itemid]=&limitstart=" + num
    doc = Nokogiri::HTML(open(url))
    doc.css(".mini-profile").each do |item|
      name = item.at_css('.searchTemplateRow13').text.to_s.strip
      email = item.at_css('.searchTemplateRow9').text.to_s.strip
      website = item.at_css('.searchTemplateRow7').text.to_s.strip
      address_1 = item.at_css('.searchTemplateRow3').text.to_s.strip
      address_2 = item.at_css('.searchTemplateRow12').text.to_s.strip
      csv << [name, email, website, address_1, address_2]
    end
  end
end


# CSV.open("chambers_of_commerce.csv", "wb") do |csv|
#   for i in 0..2 #38
#     num = i * 20
#     url = "http://www.danebuylocal.com/index.php?option=com_community&view=search&uuId=536a6dee0a5cf&params[servId]=5339&params[option]=com_community&params[view]=search&params[Itemid]=&limitstart=" + num
#     doc = Nokogiri::HTML(open(url))
#     doc.css(".mini-profile").each do |item|
#       name = item.at_css('.searchTemplateRow13').text.to_s.strip
#       email = item.at_css('.searchTemplateRow9').text.to_s.strip
#       website = item.at_css('.searchTemplateRow7').text.to_s.strip
#       address_1 = item.at_css('.searchTemplateRow3').text.to_s.strip
#       address_2 = item.at_css('.searchTemplateRow12').text.to_s.strip
#       csv << [name, email, website, address_1, address_2]
#     end
#   end
# end

