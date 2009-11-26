# Pulls the environment vars we've set in Heroku to the env_local.rb file so that
# we can run things in local dev like we do in prod. Of course, this requires
# access to the Heroku acct--something that only people able to push the live
# site will have.

namespace :env do
  
  def heroku_config_hash
    hash = {}
    config = `heroku config`
    config.lines.each do |line|
      bits = line.split
      unless bits[0] == 'RACK_ENV'
        hash[bits[0]] = bits[2]
      end
    end 
    hash  
  end
  
  desc "Pulls configuration variables from Heroku and sets them for local use"
  task :pull do
    content = "# Configuration variables pulled from Heroku\n\n"
     hash = heroku_config_hash
     hash.keys.each do |key|
       content << "ENV['#{key}'] = '#{hash[key]}'\n"
     end
     File.open("#{RAILS_ROOT}/config/initializers/env_local.rb", 'w') { |f|
       f.write(content)
     }
     puts "Wrote Heroku configuration to config/initializers/env_local.rb"    
  end
  
  desc "Creates a sample environment configuration based on active heroku config"
  task :sample do
    content = "# Configuration variables you'll need to set to play with the code\n\n"
     hash = heroku_config_hash
     hash.keys.each do |key|
      content << "ENV['#{key}'] = 'sekret'\n"
     end
     File.open("#{RAILS_ROOT}/config/initializers/env_local.rb.sample", 'w') { |f|
       f.write(content)
     }
     puts "Wrote sample Heroku configuration to config/initializers/env_local.rb.sample"    
  end
end