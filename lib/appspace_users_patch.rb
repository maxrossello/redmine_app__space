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

    def is_app_visible?(value)
      user = User.current
      return false if user.is_a?(AnonymousUser)
      user.apps.include?(value)
    end

  end
end

