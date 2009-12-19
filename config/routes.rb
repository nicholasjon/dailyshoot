ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'welcome'

  map.resources :assignments, 
                :has_many => :photos, 
                :collection => { :upcoming => :get },
                :member => { :reorder => :get }
                
  map.resources :mentions, :member => { :parse => :post }
  map.resources :photos, :member => { :regenerate => :post }
  map.resources :photogs
  map.resource  :session
  map.resources :suggestions, :member => { :thanks => :get }
  
  map.with_options(:controller => 'sessions') do |sessions|
    sessions.login  'login',  :action => 'new'
    sessions.logout 'logout', :action => 'destroy'
  end

  map.connect 'twitter/:action', :controller => 'twitter'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
