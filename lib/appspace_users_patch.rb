module AppspaceUsersPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend(ClassMethods)
    base.class_eval do
      unloadable
    end

  end

  module InstanceMethods

    APPS_DELIMITER = ','

    def apps=(value)
      write_attribute :apps, value.nil? ? "" : value.join(APPS_DELIMITER)
    end

    def apps
      read_attribute(:apps).split(APPS_DELIMITER)
    end
  end

  module ClassMethods
    @@visible_callbacks = {}

    def is_app_visible?(name, user=User.current)
      return false if user.is_a?(AnonymousUser)

      return false unless is_app_enabled?(name, user)

      user.apps.include?(name)
    end

    def is_app_enabled?(name, user=User.current)
      return false unless @@visible_callbacks[name].nil? or @@visible_callbacks[name].call(user)
      Setting.plugin_redmine_app__space['enabled'].include?(name)
    end

    def add_enabled_filter(app, func)
      @@visible_callbacks[app] = func
    end


  end
end

