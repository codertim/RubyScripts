
require "net/http"


DEBUGGING              = false
SLEEP_BETWEEN_REQUESTS = 0.3
$links_filename        = "links.txt"
links                  = []
search_term            = nil

if ARGV.size > 0
  search_term = ARGV[0]
else
  puts "Cannot find search term for search.  Missing argument on command line.  Exiting."
  exit
end


def search_links(web_links, web_search_term)
  puts "Searching links for term: #{web_search_term} ..."
  found_links = []

  web_links.each do |link|
    puts "  Searching link: #{link}"
    sleep(SLEEP_BETWEEN_REQUESTS)
    uri = URI(link)
    web_page = Net::HTTP.get(uri)
    puts "    web page: #{web_page.tr("\n", ' ').slice(0, 100)}" if DEBUGGING

    if web_page =~ /#{web_search_term}/
      puts "    Found."
      found_links << link
    else
      puts "    Not found."
    end
  end

  found_links
end


def display_found_links(found_links)
  puts "\nRESULTS"

  if found_links.empty?
    puts "No links found"
  else
    puts "  Found search link in links:"
    found_links.each {|link| puts "    #{link}"}
  end
end


file = File.open($links_filename)
file.each do |whole_line|
   line = whole_line.strip
   puts "Current line: |#{line}|"
   unless line.empty?
     links << line
   end
end


puts "Closing file"  
if !file.closed?
  file.close
end


puts "Links found: #{links}"
links_found = search_links(links, search_term)
display_found_links(links_found)


puts "Done.\n"

