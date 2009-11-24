ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'welcome'

  map.resource :assignments  
  map.resource :session
  
  map.with_options(:controller => 'sessions') do |sessions|
    sessions.login  'login',  :action => 'new'
    sessions.logout 'logout', :action => 'destroy'
  end

  map.connect 'googlehostedservice.html', 
    :controller => 'welcome', 
    :action     => 'google'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
