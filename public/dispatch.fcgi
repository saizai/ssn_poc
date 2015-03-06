#!/home/saizai_ssn/.rvm/rubies/default/bin/ruby

# Dreamhost clears environment variables when calling dispatch.fcgi, so set them here
ENV['RAILS_ENV'] ||= 'production'
ENV['HOME'] ||= `echo ~`.strip

ENV['GEM_HOME'] = File.expand_path('~/.rvm/gems/ruby-2.2.0')
ENV['GEM_PATH'] = File.expand_path('~/.rvm/gems/ruby-2.2.0') + ":" +
  File.expand_path('~/.rvm/gems/ruby-2.2.0@global')

require 'rubygems'
Gem.clear_paths
require 'bundler'
Bundler.setup(:default, :fcgi)
require 'rack'
require 'fcgi'

require File.join(File.dirname(__FILE__), '../config/environment.rb')

class Rack::PathInfoRewriter
 def initialize(app)
   @app = app
 end

 def call(env)
   # env.delete('SCRIPT_NAME')
   env['SCRIPT_NAME'] = ''  # Don't delete it--Rack::URLMap assumes it is not nil
   pathInfo, query = env['REQUEST_URI'].split('?', 2)
   env['PATH_INFO'] = pathInfo
   env['QUERY_STRING'] = query
   @app.call(env)
 end
end

app, options = Rack::Builder.parse_file('config.ru')
wrappedApp = Rack::Builder.new do
  use Rack::ShowExceptions
  use Rack::PathInfoRewriter
  run app
end

Rack::Handler::FastCGI.run wrappedApp

# Rack::Handler::FastCGI.run  Rack::PathInfoRewriter.new(SsnPoc::Application)