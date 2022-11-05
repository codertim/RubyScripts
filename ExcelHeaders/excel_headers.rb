
require "roo"

IS_DEBUG = false

puts "Starting ...\n"

excel_filename = "ExcelTest1.xlsx"

xlsx = Roo::Spreadsheet.open(excel_filename)

if IS_DEBUG
  puts "\nInfo ..."
  puts xlsx.info
  puts "\n"

  puts "\nSheets ..."
  puts xlsx.sheets
  puts "\n"
end

xlsx.each_with_pagename do |name, sheet|
  puts "\n ***** current sheet name #{name}"
  header_names = []

  if IS_DEBUG
    puts "  first row: #{sheet.first_row}"
    puts "  last row: #{sheet.last_row}"
    puts "  first column: #{sheet.first_column}"
    puts "  last column: #{sheet.last_column}"
  end

  first_row_num = sheet.first_row.to_i
  puts "first row num: #{first_row_num}"
  first_col_num = sheet.first_column.to_i
  puts "first col num: #{first_col_num}"
  last_col_num = sheet.last_column.to_i
  puts "Last col num: #{last_col_num}"

  col_title1 = sheet.cell(first_row_num, first_col_num)
  col_nums = first_col_num .. last_col_num
  col_nums.each do |current_col_num|
    current_header = sheet.cell(first_row_num, current_col_num) 
    puts " Current col num = #{current_col_num} - current col header = |#{current_header}|"
    header_names.unshift(current_header)
  end

  puts "|#{col_title1}|"
  puts "***** header_names: ", header_names
  puts "*****\n"
end

xlsx.close


puts "\nDone.\n"


