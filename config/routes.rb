RedmineApp::Application.routes.draw do
  post '/apps', :controller => 'appspace', :action => 'update'
  get '/apps(/:tab)', :controller => 'appspace', :action => 'index'
end


