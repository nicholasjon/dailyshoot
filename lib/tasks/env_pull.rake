# Pulls the environment vars we've set in Heroku to the env_local.rb file so that
# we can run things in local dev like we do in prod. Of course, this requires
# access to the Heroku acct--something that only people able to push the live
# site will have.

task :env_pull do
   content = ""
   config = `heroku config`
   config.lines.each do |line|
     bits = line.split
     unless bits[0] == 'RACK_ENV'
       content << "ENV['#{bits[0]}'] = '#{bits[2]}'\n"
     end
   end
   File.open("#{RAILS_ROOT}/config/env_local.rb", 'w') { |f|
     f.write(content)
   }
   puts "Wrote Heroku configuration to config/env_local.rb"
end
