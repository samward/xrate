require "nokogiri"
require "open-uri"
require "xrate"


namespace :xrate do
  desc "Fetch latest rates from ECB"
  task import: :environment do
    xml = open("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml")
    doc = Nokogiri::XML.parse(xml)
    doc.remove_namespaces!
    doc.xpath("//Cube[@time]").each do |day|
      date = Date.parse(day.attributes["time"].value)
      day.children.each do |entry|
        currency = entry.attributes["currency"].value
        exchange_rate = entry.attributes["rate"].value
        rate = Xrate::Rate.find_or_create_by(date: date, currency: currency)
        rate.rate = exchange_rate

        if rate.save
          puts "#{date} #{currency} #{exchange_rate} stored"
        else
          puts "Error: #{date} #{currency} #{exchange_rate} could not be stored"
        end
      end
    end
  end
end
