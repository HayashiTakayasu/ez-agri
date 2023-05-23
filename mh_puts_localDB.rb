#!ruby

#p Dir.pwd
  require "rubygems"
  require "agri-controller"
  require "redis"
require "./housa"


module Loger2
  def loger(log_file,msg,mode='daily')
    #add data to log_file
    logger=Logger.new(log_file,mode)
    logger.formatter=proc{|severity,datetime,progname,msg| "#{msg}\n"}
    logger.info(msg)
  end
end
#include Loger
  require "time"
  require "fileutils"
  require "timeout"
  def thermo_data_logger_thread
    db=Redis.new
        #begin
        #mainloop
        before=nil
     #ls=[:degree,:housa,:last_time,:rain,:roten,:zettai,:soil_temp]
        loop do
          t=Time.now
          #min=t.min
          #if min!=before
          #  before=min
            #str=`ls /dev/ttyU*`.chomp
            #str="/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_20130418180-if00-port0"
            #system("ruby mh383_test.rb #{str} 2>&1")
            system("ruby mh383_test.rb")
            
            str=File.read("mch.txt")
            p mh=MCH383::list(str)
            
            #mh.class
            t2=t.to_a
            t2[0]=0
            tt=Time.parse(t2[2].to_s+":"+t2[1].to_s+":"+t2[0].to_s)
            #p tt
            ##
            #save DATA LOGGER(default,each o'clock)

            #p word=tt.strftime("%Y-%m-%d %H:%M:%S")+", "+
            db.set("last_time",tt.strftime("%Y-%m-%d %H:%M:%S"))
            db.set("degree",mh["2"][0].round(1).to_s)
            db.set("humidity",(mh["1"][0]).round(1).to_s)
            db.set("ppm",(mh["3"][0]).to_s)
            db.set("housa",housa(mh["2"][0],mh["1"][0]).round(2).to_s)
            db.set("roten",roten(mh["2"][0],mh["1"][0]).round(2).to_s)
            db.set("zettai",zettai(mh["2"][0],mh["1"][0]).round(2).to_s)
            #seve data each minute.
            # yield word if block_given?
          #end
          sleep 20
          #p Time.now
        end
          
        #sleep 10
    #end
  end
if $0==__FILE__
  require "rubygems"
  require "agri-controller"
  include AgriController
  #include Loger
  #p "start mh_puts.rb"
  
 loop{error_catch("error_log",15,""){
    thermo_data_logger_thread #do |data|
#      Loger::loger("./thermo_data/thermo_data.csv",data)
#    #.copy("./thermo_data.csv","./thermo_data")
#    open("last_data","w"){|io| io.puts data}
#  end
  }
}
  
end
