module AppSpace
  class Hooks < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = { })
    	"#{stylesheet_link_tag 'appspace.css', :plugin => 'redmine_app__space'}
      #{javascript_include_tag 'selectize.js', :plugin => 'redmine_app__space'}
      #{stylesheet_link_tag 'selectize.css', :plugin => 'redmine_app__space'}
        <script type=\"text/javascript\">
            $(document).ready(function() {
                $('#issue_fixed_version_id, #project_quick_jump_box, #time_entry_activity_id, .selectize').selectize({
                    create: false,
                    sortField: 'text',
                    allowEmptyOption: true
                });
            });
        </script>"
    end

  end
end