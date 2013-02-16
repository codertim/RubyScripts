puts "RUBY_VERSION = #{RUBY_VERSION}"
require 'open-uri'
require 'rubygems'
require 'nokogiri'


MinSeconds = 60


def get_text_from_path(path, doc)
  all_strings = ""

  doc.css(path).each do |v| 
    current_string = v.text.strip
    all_strings += current_string
    # puts "|||#{current_string}|||" 
  end

  # puts "\nAll strings = #{all_strings}"

  all_strings.chomp
end

def get_initial_page_text(user_input_path, doc)
  page_text = nil
  is_correct = "n"

  while is_correct.downcase().chars.first != "y" do
    page_text = get_text_from_path(user_input_path, doc)
    puts "\n\nPage text: #{page_text}"
    puts "Does this look correct?"
    STDOUT.flush()
    is_correct = gets.chomp
  end

  page_text
end



# vary the intervals a bit
def get_random_seconds
  MinSeconds + rand(30)
end



puts "Enter website address:"
STDOUT.flush
url = gets.chomp
doc = Nokogiri::HTML(open(url))

threads = []
loop do
  puts "Enter css path (e.g. body table tr td[5] tt a[1]) or 'd' for done: "
  STDOUT.flush
  user_input_path = gets.chomp
  break if user_input_path.downcase == 'd'
  puts "\nSearching path: >>>#{user_input_path}<<< ..."
  # doc.css("body table tr td[5] tt a[1]").each{ |v| puts "|||#{v.text.strip}|||" }

  initial_page_text = get_initial_page_text(user_input_path, doc)
  puts "Checking initial page text ... #{initial_page_text}"

  t1 = Thread.new {
    loop do
      puts "\n\n ----------------------\n"
      sleep(get_random_seconds)
      puts "\nChecking #{url} with '#{user_input_path}' ..."
      doc = Nokogiri::HTML(open(url))
      # current_page_text = get_page_text(user_input_path, doc)
      current_page_text = get_text_from_path(user_input_path, doc)
      if initial_page_text != current_page_text
        puts "Changed!!!"
        puts "Initial: >>>#{initial_page_text}<<<"
        puts "Current: >>>#{current_page_text}<<<"
        break
      else
        puts "Not yet changed."
      end

    end 
  }

  threads << t1
end 


puts "\n\nWaiting for page sections to be checked ...\n"


threads.each do |t|
  t.join
end


puts "\nDone."




