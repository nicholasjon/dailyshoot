require 'rubygems'
require 'activeresource'
require 'highline/import'

ActiveResource::Base.logger = 
  Logger.new("#{File.dirname(__FILE__)}/active_resource.log")

def prompt(prompt, mask=true)
  ask(prompt) { |q| q.echo = mask}
end

class Assignment < ActiveResource::Base
  login = prompt('Login: ')
  password = prompt('Password: ', '*')

  #self.site = "https://#{login}:#{password}@dailyshoot.com/"  
  self.site = "http://#{login}:#{password}@localhost:3000/"
end

a = Assignment.new(:text => "Shoot something", :tag => "ds100", :date => Time.now)
puts a.save