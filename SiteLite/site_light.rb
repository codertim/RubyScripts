
require 'rubygems'
require 'open-uri'
require 'nokogiri'


class HN
  SITE_URL = "http://news.ycombinator.com/"

  def initialize(f)
    @formatter = f
  end


  def url_address
    SITE_URL
  end

 
  def squash_site(doc)
    full_result = ""
    is_ok = true
    is_in_article_zone = false

    doc.css("a").each do |v|
      if v.to_s.match(/newslogin/)
        is_in_article_zone = true
        next
      elsif v.to_s.match(/href="news2"/)
        is_in_article_zone = false
      end

      if is_in_article_zone
        if v.to_s.match(/href="user/)
          is_ok = false
        elsif v.to_s.match(/\d+ comments?/)
          is_ok = false
        else
          is_ok = true
        end 
  
        if is_ok
          # only print links we want
          # puts "#{v.text}" 
          unless v.to_s =~ /img.+src/  # we don't want images to slow network down
            # puts "|#{v}|" 
            # full_result << "#{v} <br />"
            full_result << @formatter.format_line(v)
          end
        end
      end
    end

    full_result
  end
end



class Drudge
  SITE_URL = "http://www.drudgereport.com"

  def initialize(f)
    @formatter = f
  end


  def url_address
    SITE_URL
  end

 
  def squash_site(doc)
    full_result = ""
    is_ok = true

    doc.css("a").each do |v|
        if ( (v.text.match(/AP WORLD/)) || (v.text.match(/AP WORLD/)) )
        is_ok = false

 
  def squash_site(doc)
    full_result = ""
    is_ok = true

    doc.css("a").each do |v|
      if ( (v.text.match(/AP WORLD/)) || (v.text.match(/AP WORLD/)) )
        is_ok = false
      elsif v.text.match(/X17/)
        is_ok = true
        next
      elsif v.text.match(/WABC RADIO/)
        is_ok = false
      elsif v.text.match(/BILL ZWECKER/)
        is_ok = true
      elsif v.text.match(/AGENCE/)
        is_ok = false
      end 

      if is_ok
        # only print links we want
        # puts "#{v.text}" 
        unless v.to_s =~ /img.+src/  # we don't want images to slow network down
          # puts "|#{v}|" 
          # full_result << "#{v} <br />"
          full_result << @formatter.format_line(v)
        end
      end
    end

    full_result
  end
      elsif v.text.match(/X17/)
        is_ok = true
      elsif v.text.match(/WABC RADIO/)
        is_ok = false
      elsif v.text.match(/BILL ZWECKER/)
        is_ok = true
      elsif v.text.match(/AGENCE/)
        is_ok = false
      end 

      if is_ok
        # only print links we want
        # puts "#{v.text}" 
        unless v.to_s =~ /img.+src/  # we don't want images to slow network down
          # puts "|#{v}|" 
          # full_result << "#{v} <br />"
          full_result << @formatter.format_line(v)
        end
      end
    end

    full_result
  end
end


class HtmlFormatter
  def begin
    "<html><head></head><body>"
  end

  def format_line(orig_string)
    "#{orig_string} <BR />"
  end

  def end
    "</body></html>"
  end
end


class JQueryMobileFormatter
  def begin(header)
     @counter = 0
    <<eos
    <!doctype html >
	<html>
		<head>
			<title>Site Light</title> 
			<meta name="viewport" content="width=device-width, initial-scale=1"> 
			<link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.css" />
			<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
			<script src="http://code.jquery.com/mobile/1.2.0/jquery.mobile-1.2.0.min.js"></script>
		</head>
		<body>
			<div data-role="page">
				<div data-role="header">
					#{header}
					<br />
					<br />
					<br />
				</div>
				<div data-role="content">
					<ul data-role="listview">
eos
  end

  def format_line(orig_string)
    @counter += 1
    data_theme = "a"

    if @counter % 3 == 0
      data_theme = "b"
    elsif @counter % 2 == 0
      data_theme = "a"
    else
      data_theme = "e"
    end

    "<li data-theme=#{data_theme}>#{orig_string} <li />\n"
  end

  def end
    "</ul></div></div></body></html>"
  end
end


# formatter = HtmlFormatter.new
formatter = JQueryMobileFormatter.new
site = Drudge.new(formatter)
# site = HN.new(formatter)

doc = Nokogiri::HTML(open(site.url_address))
trimmed_site = ""
trimmed_site += formatter.begin(site.url_address)
trimmed_site += site.squash_site(doc)
trimmed_site += formatter.end
# puts "\n***** trimmed_site = #{trimmed_site} "
puts "#{trimmed_site}"



