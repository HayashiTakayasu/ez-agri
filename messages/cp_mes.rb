#/bin/sh
pwd=File.dirname(__FILE__)
`sudo cp /var/log/messages* #{pwd}`
`sudo chmod 777 #{pwd}/messages*`
`sudo rm -rf /var/log/messages.*.gz`
