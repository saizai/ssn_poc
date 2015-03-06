#!/home/saizai_ssn/.rvm/rubies/default/bin/ruby

# Dreamhost clears environment variables when calling dispatch.fcgi, so set them here
ENV['RAILS_ENV'] ||= 'production'
ENV['HOME'] ||= `echo ~`.strip

ENV['GEM_HOME'] = File.expand_path('~/.rvm/gems/ruby-2.2.0')
ENV['GEM_PATH'] = File.expand_path('~/.rvm/gems/ruby-2.2.0') + ":" +
  File.expand_path('~/.rvm/gems/ruby-2.2.0@global')

require 'rubygems'
Gem.clear_paths
require 'fcgi'

require File.join(File.dirname(__FILE__), '../config/environment.rb')

class Rack::PathInfoRewriter
 def initialize(app)
   @app = app
 end

 def call(env)
   env.delete('SCRIPT_NAME')
   parts = env['REQUEST_URI'].split('?')
   env['PATH_INFO'] = parts[0]
   env['QUERY_STRING'] = parts[1].to_s
   @app.call(env)
 end
end

Rack::Handler::FastCGI.run  Rack::PathInfoRewriter.new(SsnPoc::Application)