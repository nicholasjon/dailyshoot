ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'welcome'

  map.resources :assignments, 
                :has_many => :photos, 
                :collection => { :upcoming => :get }
  map.resources :mentions
  map.resources :photogs
  map.resource  :session
  map.resources :suggestions
  
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
