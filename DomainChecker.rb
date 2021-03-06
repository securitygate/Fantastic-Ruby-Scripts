#!/usr/bin/env ruby
=begin
DomainChecker.rb: Checks to see if the domains on server are being hosted
Last Revision: Nov 26, 2012
=end

class DomainCheck
  def vhost_grab
    vhost_path = Dir["/etc/httpd/conf.d/vhost_*"]
    vhost_path.each do |d|
      if d.include? "000"
        vhost_path.delete(d)
      end
#      puts d
    end
  end

  def ip_address(vhosts)
    vhosts.map! do |x|
       x = open(x).grep(/<VirtualHost .*:80>/).to_s.gsub!(/:80>/,"").gsub!(/<VirtualHost/, "")
    end
  end

  def vhost_shortener(long_vhost)
    long_vhost.map! do |x|
      x.gsub("/etc/httpd/conf.d/vhost_", '').gsub(".conf",'')
    end
  end

  def formatted_header
    puts "\n%s %40s %41s" %["Domain name", "IP Address Listed", "IP Address Currently in Use"]
  end

  def padding_for(final_vhost)
#    puts *final_vhost.to_s.length
    final_vhost.to_s.length
  end

  def domain_display(final_vhost, display_ip)
    display_ip.each_index do |x|
      padding = 49 - final_vhost[x].strip.length
      print "%s" %[final_vhost[x]]
      print "%#{padding}s" %[display_ip[x].strip]
      puts "%35s" %[`dig #{final_vhost[x]} +short`.strip]
    end
  end
end

d1 = DomainCheck.new
display_ip = d1.ip_address(d1.vhost_grab)
final_vhost = d1.vhost_shortener(d1.vhost_grab)
d1.formatted_header
d1.domain_display(final_vhost, display_ip)

