require 'redmine'

Rails.logger.info 'Starting Application Space plugin for Redmine'

Redmine::Plugin.register :redmine_app__space do
  name 'Redmine Application Space plugin'
  author 'Massimo Rossello'
  description 'Creates a global application space with configurable application menu entries'
  version '1.0.0'
  url 'https://github.com/maxrossello/redmine_app__space.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '2.0.0'

  menu :top_menu, :appSpace, { :controller => 'appspace', :action => 'index', :tab => nil }, :caption => :label_applications, :if => Proc.new { User.current.logged? }
  menu :admin_menu, :appSpace, {:controller => 'settings', :action => 'plugin', :id => "redmine_app__space"}, :caption => :label_applications

  unless User.included_modules.include?(AppspaceUsersPatch)
    User.send(:include, AppspaceUsersPatch)
  end

  unless ActionDispatch::Routing::Mapper.included_modules.include?(AppspaceRoutesPatch)
    ActionDispatch::Routing::Mapper.send(:include, AppspaceRoutesPatch)
  end

  settings(:default => {
      'enabled' => [],
      'available' => [],
      'auth_group' => {}
    },
    :partial => 'appspace/application_settings'
  )

end


require_dependency 'appspace/hooks'

# needs to be evaluated before /apps(/:tab)!
RedmineApp::Application.routes.prepend do
  application 'timelog', :to => 'timelog#index', :via => :get
  application 'activity', :to => 'activities#index', :via => :get
  block 'calendar', 'my/blocks/calendar'
  block 'issuesassignedtome', 'my/blocks/issuesassignedtome'
  block 'issuesreportedbyme', 'my/blocks/issuesreportedbyme'
  block 'news', 'my/blocks/news'
  block 'issueswatched', 'my/blocks/issueswatched'
end
