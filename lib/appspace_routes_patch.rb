module AppspaceRoutesPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end

  end

  module InstanceMethods

    def application(name, options=nil)
      Setting.plugin_redmine_app__space['available'] = [] if Setting.plugin_redmine_app__space['available'].nil?
      Setting.plugin_redmine_app__space['available'] << { :name => name }

      User.add_enabled_filter(name, options[:if]) unless (options.nil? or options[:if].nil?)
      options.delete(:if)

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

      match("/apps/#{name}", options)
    end

  end
end

