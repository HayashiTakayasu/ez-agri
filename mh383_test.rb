require "timeout"
device=ARGV[0] || '/dev/ttyUSB0'
#device="/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_20130418180-if00-port0"
#device="/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_20130109082-if00-port0"
#device="/dev/serial/by-id/"+File.read("config/mch383.txt")

`sudo chmod 777 #{device}`
begin
  Timeout.timeout(15) do
    begin
      p res=`sudo python2 ./mch.py #{device} 2>&1;echo $?`
      #p  res
      res2=res.split("\n")
    rescue
      sleep 5
      p "retry mch"
      retry
    end
    
    if res2.last!="0"
      sleep 5
      #Again try
      print a="#{Time.now.to_s},mh383_test.rb ERROR:#{res.inspect}"
      open("./error_log","a+"){|io| io.puts a}
      res=`python ./mch.py #{device} 2>&1;echo $?`
      #p res
      res2=res.split("\n")
      #error twice REBOOT
      if res2.last!="0"
        print a="#{Time.now.to_s},sudo reboot:#{res.inspect}"
        open("./error_log","a+"){|io| io.puts a}
        #system("sudo reboot")
      end
    end
  end
rescue Timeout::Error
  p "mh383_test.rb Timeout::Error.#{Time.now}"
  str=File.read("./app.pid")
  p command="kill -9 #{str}"
  p `#{command}`
  open("error_mh383_test.txt","a"){|io| io.puts Time.now.to_s+" "+command}
#  retry
end
#x=File::read("mch.txt")
#if x
#require "rubygems"
#require "agri-controller"
#include AgriController
 #puts res=MCH383::parse(x)
#end
