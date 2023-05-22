require "agri-controller"
require "redis"
include AgriController
port=""#"/dev/ttyAMA0"
log_file="../log/db.txt"
`touch #{log_file}`

##redis numato server
#ch0[:numato,"relay on V"]

db=Redis.new
if ARGV[0]!="--noreset"
#reset at first
db.del(:numato)
db.rpush(:numato,"reset") 
sleep 2

db.set("numato_bit","0")
bit=Bit.new(0)
else
p b=db.get("numato_bit")
bit=Bit.new(0)

end

manual_0  = yaml_dbr("manual_0.txt","../bin_ac/cgi-bin/config/manual_0.txt")
manual_0_bit= Bit.new(manual_0)
p manual_0_bit
m0=manual_0_bit.tos(32,2)
db.set("manual_0",m0)

manual_1=yaml_dbr("manual_1.txt","../bin_ac/cgi-bin/config/manual_1.txt")
manual_1_bit=Bit.new(manual_1)
p m1=manual_1_bit.tos(32,2)
db.set("manual_1",m1)

#set to numato32 
m0.size.times do |i| 
 p i
 bool=m0[i*-1-1]
 if bool=="1"
   if m1[i*-1-1]=="1"
     db.rpush(:numato,"relay on #{i.to_s(36).upcase}")
   end
 end
end

p __FILE__+" start" 
loop do
  sleep 1
  while command=db.blpop(:numato,:time_out => 0.1)
    begin
      #p command
      if command[1]
        arg=command[1].split(" ")
        #p arg
        
        #bit set      
        if arg[0]=="relay"
          m0=db.get("manual_0")
          if arg[1]=="on"
            i=arg[2].to_i(36)
            m1=db.get("manual_1")
            #p "on"
            unless m0[-i-1]=="1" && m1[-i-1]=="0"
              bit.on(i)
            else
              ##break if manual off
              p "manual off"
              next
            end 
          elsif arg[1]=="off"
            i=arg[2].to_i(36)
            m1=db.get("manual_1")
            #p "off"
            unless m0[-i-1]=="1" && m1[-i-1]=="1"
              bit.off(arg[2].to_i(36))
            else
              ##break if manual on
              p "manual on"
              next
            end
          else
            p "else" 
           #no change
          end
          bit_str=bit.tos(32,2)
          db.set("numato_bit",bit_str)
        elsif arg[0]=="reset" 
          bit_str="00000000000000000000000000000000"
        else
          bit_str=bit.tos(32,2)
        end
        
        data=Time.now.strftime("%Y-%m-%d %H:%M:%S")+","+bit_str+","+command[1]
        system("sudo chmod 666 /dev/ttyA*")
        p str=%!python namuto.py "#{command[1]}" #{port}!
        
        res0=`#{str}`
        data=data+","+res0.gsub("\n\r","|").gsub("\n","|")
        
        p data
        Loger::loger(log_file,data)
      else
        ##normaly
      p "normaly"
        data=Time.now.strftime("%Y-%m-%d %H:%M:%S")+","+command[1]
        
        str=%!python namuto.py "#{command[1]}" #{port}!
        begin
          res0=`#{str}`
          res=res0.gsub("\n\r","|")
          data=data+","+res
        rescue
          p res0 #none
        end
        
        p data=data+", "
        Loger::loger(log_file,data)  
      
      end
    rescue
    p "rescue"
        data=Time.now.strftime("%Y-%m-%d %H:%M:%S")+","+command[1]
       
        p str=%!python namuto.py "#{command[1]}" #{port}!
        res=`#{str}`
        p data=data+","+res.gsub("\n\r","|")
       Loger::loger(log_file,data)  
    end
    
  sleep 0.5  
  end

end

