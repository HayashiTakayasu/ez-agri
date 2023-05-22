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
if (argc >= 3): 
  ports  =argvs[2]
  command=argvs[1]
elif argc>=2:
  ports="/dev/ttyACM0"
  command=argvs[1]
else:
  ports="/dev/ttyACM0"
  command="reset"


print(ports)
command=command+"\n\r"
print(command)
com = Serial(
  port=ports,
  baudrate=9600,
  bytesize=8,
  parity='N',
  stopbits=1,
  timeout=1,#None,
  xonxoff=0,
  rtscts=0,
  writeTimeout=1,#None,
  dsrdtr=None)

#print com.portstr
#com.write("%01#RDD0000000015**\r")
com.flush()

i=0
com.write(command)
#res=com.read
com.close()

#print len(res)
#print res
#with open('res.txt', 'w+b') as file:
#  file.write(res)

