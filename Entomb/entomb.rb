
require "open3"
require "securerandom"


def encrypt(filename)
  puts "Encrypting file: #{filename} ..."
  puts "***** ", gets
  puts "***** ", gets

  # cipher_help = `gpg -h | grep Cipher`
  stdin, stdout, stderr = Open3.popen3("gpg -h | grep Cipher")
  # puts "cipher_help = ", cipher_help
  all_ciphers = stdout.gets.chomp
  puts "stdout=", stdout.gets
  
  all_ciphers = all_ciphers.gsub(/Cipher: /, '').chomp
  puts "all ciphers = |#{all_ciphers}|"
  
  ciphers = all_ciphers.split(", ")
  puts "ciphers = #{ciphers.inspect}"
  # puts "ciphers.sample = #{ciphers.rand}"

  ciphers_to_use = []
  preferred_cipher = "AES256"
  # puts "***** GOT HERE ciphers_to_use = #{ciphers_to_use.inspect} #####"
  if ciphers.include?(preferred_cipher)
    # puts "***** GOT HERE #####"
    ciphers_to_use << preferred_cipher
    ciphers.delete(preferred_cipher)
  else
    ciphers_to_use << ciphers.delete_at(SecureRandom::random_number * ciphers.length)
  end
  ciphers_to_use << ciphers.delete_at(SecureRandom::random_number * ciphers.length)
  puts "Encrypting with = ", ciphers_to_use

  puts "Enter password: "
  p1 = STDIN.gets.chomp
  puts "Enter password again: "
  p1b = STDIN.gets.chomp
  if p1 != p1b
    raise "ERROR: passwords do not match"
  end
  
  puts "Enter 2nd password for 2nd encryption (or hit enter if re-use same password):"
  p2 = STDIN.gets.chomp
  if p2.empty?
    p2 = p1
  else
    puts "Enter 2nd password again: "
    p2 = STDIN.gets.chomp
  end
  
  # puts "p1 = |#{p1}|"
  # puts "p2 = |#{p2}|"
  
  stdin1, stdout1, stderr1 = Open3.popen3("gpg -c --cipher-algo #{ciphers_to_use[0]} --passphrase #{p1} #{filename}")
  puts "After Open3.popen3 stdout = ", stdout1.gets
  puts "After Open3.popen3 stderr = ", stderr1.gets
  # puts "After Open3.popen3 stdin =  ", stdin1.inspect
  
  stdin2, stdout2, stderr2 = Open3.popen3("gpg -c --cipher-algo #{ciphers_to_use[1]} --passphrase #{p2} #{filename}.gpg")
  puts "After Open3.popen3 stdout = ", stdout2.gets
  puts "After Open3.popen3 stderr = ", stderr2.gets
 
end   # encrypt



def decrypt(filename)
  puts "Decrypting file: #{filename} ..."
  p1 = "test"
  # filename = "test_dec.txt.gpg.gpg"

  puts "Pass 1 decryption ..."
  new_filename1 = filename.slice(0, filename.length - 4)  # get rid of last 4 chars ".gpg"
  puts " creating file: #{new_filename1}"
  stdin1, stdout1, stderr1 = Open3.popen3("gpg -d --passphrase #{p1} #{filename} > #{new_filename1}")
  puts "stdout = ", stdout1.gets
  puts "stderr = ", stderr1.gets

  puts "Pass 2 decryption ..."
  p2 = p1
  new_filename2 = filename.slice(0, filename.length - 8)  # get rid of last 8 chars ".gpg.gpg"
  puts " creating file: #{new_filename2}"
  stdin2, stdout2, stderr2 = Open3.popen3("gpg -d --passphrase #{p2} #{filename} > #{new_filename2}")
  puts "stdout = ", stdout2.gets
  puts "stderr = ", stderr2.gets
end



if ARGV.size == 0
  puts "Missing filename"
  exit
elsif ARGV[0] == "-d"
  decrypt(ARGV[1])
else
  encrypt(ARGV[0])
end 



