Dir.chdir(File.dirname(__FILE__))

loop do
  system("xterminal -e ruby ./tuple_watch.rb")
  sleep 60
end
