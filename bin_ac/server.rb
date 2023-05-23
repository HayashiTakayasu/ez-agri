require "rubygems"
require "agri-controller"
include AgriController
load("./webrick_test.rb")
#chroot dir
p root=File.dirname($0)
Dir.chdir root
#Save program-ID
p pid=Process.pid
open("server_pid","w"){|io| io.print pid.to_s}
p web_root=Dir.pwd
webrick_start(web_root,80)
