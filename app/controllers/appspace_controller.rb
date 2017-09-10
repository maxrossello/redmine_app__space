require_dependency 'appspace_users_patch'

class AppspaceController < ApplicationController
  unloadable

  helper :my
  helper :issues
  helper :users
  helper :custom_fields

  before_filter :require_login

  def index
    @user = User.current if @user.nil?
    @tabs = (Setting.plugin_redmine_app__space['available'] || []).uniq{ |x| x[:name] }
    @tabs.sort! { |x,y| l("label_#{x[:name]}") <=> l("label_#{y[:name]}") }
    @tabs.each do |tab|
      name = tab[:name]
      if(name != nil)
       Redmine::MenuManager.map('application_menu').delete(name.to_sym)
       Redmine::MenuManager.map('application_menu').push(name, { :controller => 'appspace', :action => 'index', :tab => name },
          :caption => "label_#{name}".to_sym,
          :if => Proc.new {
              |p| User.respond_to? :is_app_visible? and User.is_app_visible?(name.to_s)
          }) if Setting.plugin_redmine_app__space['enabled'].include?(name)
      end
    end

    @application = params[:tab] if @application.nil?
    params[:tab] = @application

    @index = @tabs.index { |x| x[:name] == @application } unless @application.nil?

    if @index.nil? and !@application.nil?
      render_404
    else
      render "appspace/applications"
    end
  end

  def update
    user = User.find(params[:user_id])
    user.apps = params[:apps]
    user.save
    redirect_to :action => "index"
  end

end
