Dir.chdir(File.dirname(__FILE__))
def log(file,str)
  p str
  open(file,"a+"){|io| io.puts Time.now.strftime("%Y-%m-%d %H:%M:%S")+","+str}
  
end

def exec_rb(filename,sleep_sec=0,dir="./",test=false)
  base=Dir.pwd
  Dir.chdir(dir)
  log("log.txt",filename)
  p str="lxterminal -e ruby #{dir+filename} &"
  system(str) unless test
  sleep sleep_sec
end

str=`ps aux |grep ruby`
p ls=[
"rain.rb",
#"db_copy_localDB3.rb",

"mh_puts_localDB.rb",

#"soil_temp_rain_2reverse.rb",

"puts_db.rb","main_ma.rb",
"window0.rb",

#"window1.rb","window2.rb",
#"co2.rb",

#"fan.rb",

#,"fan_2.rb",
#"heater.rb",#"heater_fan.rb",
#"heater_2.rb",
#"boiler.rb"
#"curtain1_open.rb",

"curtain0_open.rb",

#"curtain0_open.rb",
#"light.rb","light_2.rb"

"circulator.rb"

#,"circulator_2.rb",
#"mist.rb","mist_2.rb",#"curtain1_open.rb",
]
p ls.size
#"ma_puts_ac.rb"

#,"usbrh_loop.rb"
=begin
,"cputemp_loop.rb",
      "circulator.rb","fan.rb","heater.rb","curtain.rb",
      "controller_window.rb","controller_window2.rb","controller_window3.rb",
      "illi1.rb","illi2.rb","illi3.rb","illi4.rb",
      "light.rb","light2.rb","light3.rb","light4.rb","light5.rb",
      "co2.rb",
      ]
=end


#"numato_server.rb"
#"server.rb"
ls.each do |filename|
  unless str.include?(filename)
    p Time.now
    exec_rb(filename,0,"./")
  end
end

=begin
unless str.include?("numato_server.rb")
  #p "t"
  log("log.txt",ls[0])
#  system("cat ./mch.txt >> ./error_mch.txt")
#  system("lxterminal -e /home/pi/.rvm/bin/ruby ./#{ls[0]}") 
#  sleep 20 #Wait TupleSpace initialize
end

unless str.include?(ls[1])
  #p "s"
  log("log.txt",ls[1])
#  system("lxterminal -e /home/pi/.rvm/bin/ruby ./#{ls[1]}")
end

unless str.include?(ls[2])
  #p "s4"
  log("log.txt",ls[2])
#  system("lxterminal -e /home/pi/.rvm/bin/ruby ./#{ls[2]}")
end
=end
