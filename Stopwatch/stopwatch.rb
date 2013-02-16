


sleep_time = 1   # default
max_time   = nil # nil means infinite
show_full_date_time = false
compact_output      = false

if ARGV[0][0].chr == "-"
  sleep_time = ARGV[1].to_i if ARGV[1]
  max_time   = ARGV[2].to_i if ARGV[2]
  flags = ARGV[0]
  show_full_date_time = true if flags =~ /l/
  compact_output = true if flags =~ /c/
else
  sleep_time = ARGV[0].to_i if ARGV[0]
  max_time   = ARGV[1].to_i if ARGV[1]
end

initial_time = Time.now

puts "Sleep timer: #{sleep_time} seconds"


if ARGV[0] == "-h"
  puts "Usage: ruby stopwatch.rb [interval] [max]\n\n"
  exit(0)
end


puts


loop do
  sleep(sleep_time)
  puts "Current date/time: #{Time.now.to_s}" if show_full_date_time

  current_time = Time.now
  elapsed_seconds = (current_time - initial_time).to_i
  print "Elapsed: #{elapsed_seconds} seconds"
  if compact_output
    print ".  "
    STDOUT.flush()
  else
    puts
  end

  if !max_time.nil?
    break if elapsed_seconds > max_time
  end
end



BEGIN { puts "\nStarting ..." }
END   { puts "\nDone.\n" }

