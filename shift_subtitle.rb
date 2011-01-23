require 'optparse'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby shift_subtitle.rb --delay='delaytime' --file=subtitlefile"

  opts.on("--delay N", Integer, "specify the delay time, can be negative or positive") do |v|
    options[:delay] = v
  end

  opts.on("--file F", String, "specify the filename in srt format") do |v|
    options[:file] = v
  end
end.parse!

if options[:delay].nil?
  puts "delay time required"
  exit 0
elsif options[:file].nil? or !File.exist?(options[:file])
  puts "File not found"
  exit 0
end
	
f = File.open(options[:file])
f.each_line do |l|
  # "01:25:15,049 --> 01:25:18,712\r\n"
  if l =~ /([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{0,3})\s-->\s([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{0,3})/
    h,m,sz = $1.split(":")
    s,z = sz.split(",")
    f = s.to_i + m.to_i*60 + h.to_i*60*60
		
    fx = f + options[:delay]
    hx,y = fx.divmod(60*60)
    mx,sx = y.divmod(60)
    replacement = "#{hx.to_s.rjust(2,'0')}:#{mx.to_s.rjust(2,'0')}:#{sx.to_s.rjust(2,'0')},#{z}"
		
    h,m,sz = $2.split(":")
    s,z = sz.split(",")
    f = s.to_i + m.to_i*60 + h.to_i*60*60
		
    fx = f + options[:delay]
    hx,y = fx.divmod(60*60)
    mx,sx = y.divmod(60)
    replacement2 = "#{hx.to_s.rjust(2,'0')}:#{mx.to_s.rjust(2,'0')}:#{sx.to_s.rjust(2,'0')},#{z}"
		
    puts("#{replacement} --> #{replacement2}")
  else
    puts(l)
  end
end
