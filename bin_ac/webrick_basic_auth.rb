#!ruby
#coding:utf-8

#require 'pathname'
require 'webrick'
module AgriController
    module WEBrick::HTTPServlet
      FileHandler.add_handler('rb', CGIHandler)
    end
  module_function
  def webrick_start(root=Dir.pwd,port=10080,auth='guest',pass='passwd')
    #p approot=Pathname.pwd.parent
    app_root =root#File.expand_path(File.dirname(__FILE__) + '/..')
    
    p document_root = app_root + '/htdocs'
    if RUBY_PLATFORM.include?("mswin")
      p rubybin = 'c:/ruby187/bin/rubyw.exe'
    else#liux
      rubybin = `which ruby`.chomp
    end
    server = WEBrick::HTTPServer.new({
      :DocumentRoot => document_root,
      :BindAddress => '0.0.0.0',
      :CGIInterpreter => rubybin,
      :Port => port,
      :RequestCallback => lambda do |req, res|
         if req.path =~ %r(^/cgi-bin/) 
           WEBrick::HTTPAuth.basic_auth(req, res, "Login") do |username, password|
             username == auth && password == pass
           end
         end
      end
    })
    
    # App/cgi/
    app_root + '/cgi-bin/*.{cgi,rb}'
    cgilist = Dir.glob(app_root + '/cgi-bin/*.{cgi,rb}')
    
    cgilist.each {|cgi_file|
      p cgi_file
      cgi_file_name = File.basename(cgi_file)
      
      server.mount('/cgi-bin/' + cgi_file_name, WEBrick::HTTPServlet::CGIHandler, cgi_file)
      
    }
    
    ['INT', 'TERM'].each {|signal|
      Signal.trap(signal){ server.shutdown }
    }
    
    server.start
  end
end

if $0==__FILE__
#$KCODE="s"
  port=ARGV[0] || "10080"
  p au=File.read("cgi-bin/config/a.txt").chomp
  p pa=File.read("cgi-bin/config/p.txt").chomp
  AgriController::webrick_start(Dir.pwd,port,au,pa)
end
