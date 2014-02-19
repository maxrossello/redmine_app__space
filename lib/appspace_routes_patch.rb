module AppspaceRoutesPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end

  end

  module InstanceMethods

    def update_menu(name)
      Redmine::MenuManager.map('application_menu').delete(name.to_sym)
      Redmine::MenuManager.map('application_menu').push(name, { :controller => 'appspace', :action => 'index', :tab => name },
                :caption => "label_#{name}".to_sym,
                :if => lambda {
                    |p| User.respond_to? :is_app_visible? and User.is_app_visible?(name.to_s)
                }) if Setting.plugin_redmine_app__space['enabled'].include?(name)
      Redmine::MenuManager.items('application_menu').children.sort!{ |x,y| ::I18n.t("label_#{x.name}") <=> ::I18n.t("label_#{y.name}") }
    end

    def application(name, options=nil)
      Setting.plugin_redmine_app__space['available'] = [] if Setting.plugin_redmine_app__space['available'].nil?
      Setting.plugin_redmine_app__space['available'] << { :name => name }

      User.add_enabled_filter(name, options[:if]) unless (options.nil? or options[:if].nil?)
      options.delete(:if)

      update_menu(name)

      match("/apps/#{name}", options)
    end

    def block(name, partial, options={})
      Setting.plugin_redmine_app__space['available'] = [] if Setting.plugin_redmine_app__space['available'].nil?
      Setting.plugin_redmine_app__space['available'] << { :name => name, :partial => partial }

      options[:via] = :get if options[:via].nil?
      options[:to] = "appspace#index"
      options[:tab] = name

      User.add_enabled_filter(name, options[:if]) unless (options.nil? or options[:if].nil?)
      options.delete(:if)

      update_menu(name)

      match("/apps/#{name}", options)
    end

  end
end

