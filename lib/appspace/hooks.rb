module AppSpace
  class Hooks < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = { })
    	stylesheet_link_tag 'appspace.css', :plugin => 'redmine_app__space'
    end

  end
end