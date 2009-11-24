require 'rubygems'
require 'activeresource'

ActiveResource::Base.logger = 
  Logger.new("#{File.dirname(__FILE__)}/active_resource.log")

class Assignment < ActiveResource::Base
  # self.site = "http://dailyshoot.com/"
  self.site = "http://localhost:3000/"
end

assignments = Assignment.find(:all)
puts assignments.map(&:text)
