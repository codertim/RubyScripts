
$flash_card_file  = nil
$is_front_section = true
$shuffle_cards    = false
$flip_cards       = false
DEBUGGING         = false

puts "Starting ..."

if ARGV.empty?
  puts "Missing flash card text file command line argument"
else
  $flash_card_file = ARGV.first  
end


puts "Process in order or randomize:"
puts "  1) in order"
puts "  2) randomize"
sequence = $stdin.gets.chomp
puts "You chose: |#{sequence}|"
if sequence == "2"
  $shuffle_cards = true
end

puts "Flip cards (show back then front)"
puts "  1) no"
puts "  2) yes"
flip = $stdin.gets.chomp
puts "You chose: |#{flip}|"
if flip == "2"
  $flip_cards = true
end



puts "Reading file: #{$flash_card_file}"
file_lines = IO.readlines($flash_card_file)
puts "  File lines size: #{file_lines.size}"

cards = Hash.new

puts "Processing lines from file ..."
file_lines.each do |line|
  puts "Current line: #{line}" if DEBUGGING

  if $is_front_section
    if line =~ /#####/
      puts "\nFinished front section, proceeding to back section"   if DEBUGGING
      $is_front_section = false
    end
  end

  if $is_front_section
    if line =~ /(\d+)\./
      card_id = $1
      puts "  Found line beginning with digits: #{card_id}" if DEBUGGING
      line =~ /\d+\.\s+(.+)/
      front = $1
      puts "  Content after digits: #{front}" if DEBUGGING
      cards[card_id] = [front]
    end

  else   # process back sides of cards 
    if line =~ /(\d+)\./
      card_id = $1
      puts "  Found line beginning with digits: #{card_id}" if DEBUGGING
      line =~ /\d+\.\s+(.+)/
      back = $1
      puts "  Backside content after digits: #{back}" if DEBUGGING
      puts "  Card before adding back: #{cards[card_id]}" if DEBUGGING 
      cards[card_id] << back 
    end
    
  end
end

puts "\nCards after processing: #{cards}" if DEBUGGING


card_keys = cards.keys
card_keys.shuffle! if $shuffle_cards
card_keys.each do |card_key|
  current_card = cards[card_key]

  print "Current card front: "
  if $flip_cards
    print "#{current_card.slice(1)}"
  else
    print "#{current_card.slice(0)}"
  end

  puts "\n  >>> Hit <enter> to see back and continue <<<"
  input = $stdin.gets

  print "  Back for current card: "
  if $flip_cards
    print current_card.slice(0)
  else
    print current_card.slice(1)
  end

  puts "\n\n"
end


puts "Done.\n"



