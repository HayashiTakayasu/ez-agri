file=ARGV[0]
if ARGV[0]
 str=File.read(file).force_encoding("ASCII-8bit")
 puts str[3].ord*255+str[4].ord
 exit(0)
else
 exit(1)
end
