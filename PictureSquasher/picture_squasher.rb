
# raw images are usually very big, so created this program to resize
# them to 800 width; height is not specified to aspect ratio is
# maintained

NEW_IMAGE_WIDTH    = 800
ORIGINALS_DIR_NAME = "Originals"
RESIZED_DIR_NAME   = "Resized"


puts "\nStarting ...\n\n"

executable_path = `which convert`

if executable_path.empty?
  puts "Cannot find image magick"
  exit 0
end

image_files = Dir.entries(".").select {|v| v =~ /jpg$/i }   # find .jpg and .JPG files
image_files.reject! {|f| f =~ /^orig/ }   # do not include those that start with "orig_"

if image_files.empty?
  puts "Cannot find any images"
  exit 0
end


# make copies of images in case anything goes wrong
unless Dir.exist?(ORIGINALS_DIR_NAME)
  Dir.mkdir(ORIGINALS_DIR_NAME)
end

image_files.each do |image|
  image_copy = "orig_#{image}"
  if File.exist?(image_copy)
    puts "  file copy already exists: #{image_copy}"
  else
    `cp #{image} ./#{ORIGINALS_DIR_NAME}/#{image_copy}`
  end
end


# shrink images
unless Dir.exist?(RESIZED_DIR_NAME)
  Dir.mkdir(RESIZED_DIR_NAME)
end

image_files.each do |image|
  puts "Current image: #{image}"
  image_name_parts = image.split(".")
  resized_image_name = image_name_parts[0] + "_w#{NEW_IMAGE_WIDTH}" + "." + image_name_parts[1]
  # puts "resized image name: #{resized_image_name}"
  shrink_command = "convert #{image} -resize #{NEW_IMAGE_WIDTH} ./#{RESIZED_DIR_NAME}/#{resized_image_name}"
  puts "  executing: #{shrink_command}"
  `#{shrink_command}`
end


puts "\nDone.\n\n"




