#!/bin/sh
cd `dirname $0`

redis-server redis.conf &
sleep 5

cd ./io
lxterminal -e /home/pi/.rvm/bin/ruby numato_server.rb &
sleep 5
cd -
/home/pi/.rvm/bin/ruby ./messages/cp_mes.rb &



cd ./bin_ac
lxterminal -e sudo /home/pi/.rvm/bin/ruby ./server.rb &
cd -

lxterminal -e /home/pi/.rvm/bin/ruby ./tuple.rb &
firefox  127.0.0.1/main  --allow-file-access-from-files&
