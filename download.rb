require 'nokogiri'
require 'uri'
require 'open-uri'
require 'pry'
require 'pry-byebug'
require 'net/http'

base_uri   = URI.parse('http://www-pw.physics.uiowa.edu/plasma-wave/voyager/')
index_uri  = URI.join(base_uri, 'local1/DATA/FULL/')
index_doc  = Nokogiri::HTML(open(index_uri))

index_doc.css('a').each do |index_link|

  if index_link['href'] =~ /\/local1\/DATA\/FULL\/.*\/$/
    folder_uri = URI.join(base_uri, index_link['href'].gsub(/\.\.\//, ''))
    folder_doc = Nokogiri::HTML(open(folder_uri))

    folder_doc.css('a').each do |file_link|
      filename = file_link['href']

      if filename =~ /.*\.DAT$/
        file_uri = URI.join(folder_uri, filename)

        open("./data/#{filename}", "wb") do |file|
          open(file_uri, "rb") do |resp|
            file.write(resp.read)
          end
        end

      end
    end
  end
end
