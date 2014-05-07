require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

# CSV.open("danebuylocal.csv", "wb") do |csv|
#   for i in 0..38
#     num = (i * 20).to_s
#     url = "http://www.danebuylocal.com/index.php?option=com_community&view=search&uuId=536a6dee0a5cf&params[servId]=5339&params[option]=com_community&params[view]=search&params[Itemid]=&limitstart=20" + num
#     doc = Nokogiri::HTML(open(url))
#     selector = "//a[starts-with(@href, \"mailto:\")]/@href"
#     nodes = doc.xpath selector
#     email = nodes.collect {|n| n.value[7..-1]}
#     csv << [name, email]
#   end
# end

CSV.open("danebuylocal.csv", "wb") do |csv|
  url = "http://www.danebuylocal.com/index.php?option=com_community&view=search&uuId=536a6dee0a5cf&params[servId]=5339&params[option]=com_community&params[view]=search&params[Itemid]=&limitstart=20"
  doc = Nokogiri::HTML(open(url))
  doc.css(".mini-profile").each do |item|
    item.css('a').each_with_index do |link, index|
      if index == 1
        name = link.text
      elsif index == 2
        email = link.text
      elsif index == 3
        website = link.text
      end
    end
    puts name
    address_1 = item.at_css('.searchTemplateRow3').text
    address_2 = item.at_css('.searchTemplateRow12').text
    #csv << [name, email, website, address_1, address_2]
  end
end