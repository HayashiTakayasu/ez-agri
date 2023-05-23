res=`sudo python k30_test.py;echo $?`
file=ARGV[0] || "k30_co2.txt"

#p file
if File.exist?(file) && res=="0\n"
  str=File.read(file).force_encoding("ASCII-8bit")
  begin
    puts str[3].ord*255+str[4].ord
    exit(0)
  rescue
    exit(1)
  end
else
 exit(1)
end
