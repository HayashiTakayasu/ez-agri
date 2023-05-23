#!/usr/bin/python
from serial import Serial
#import Serial
import os
import sys
import signal, time  
  
PIDFILE='./app.pid'  
pid=str(os.getpid())  
f=open(PIDFILE, 'w')  
f.write(pid)  
f.close()  


argvs=sys.argv
argc=len(argvs)
if (argc >= 2): 
  ports=argvs[1]
else:
  ports="/dev/ttyAMA0"

os.system('sudo chmod 777 /dev/ttyA*')
com = Serial(
  port=ports,
  baudrate=9600,
  bytesize=8,
  parity='N',
  stopbits=1,
  timeout=None,#1,#None,
  xonxoff=0,
  rtscts=0,
  writeTimeout= 1,#None,
  dsrdtr=None)
  #print com.portstr
command="\xFE\x06\x00\x1F\x00\x00\xAC\x03"
com.write(command)
#com.flush  

#while 1:
res=com.read(8)
com.close()

#  if res=="\002":
#    res=res+com.read(47)
#    break
#  else:
#    pass
bool=(res==command)
print bool

#tobe =>"\u000242010100000098\r\u000243190000000518\r\xFF\u000241040100000856" failed
#     =>"\u000242010100000098\r\u000243190000000518\r\u000241040100000856\r"
#status=os.system("/home/agri/.rvm/rubies/ruby-2.0.0-p247/bin/ruby ./check_mch.rb")
#bool=(status==0)

#print bool
#print res

with open('k30_ABC.txt', 'w+b') as file:
  #file.write(res)
  file.write("disabled")
