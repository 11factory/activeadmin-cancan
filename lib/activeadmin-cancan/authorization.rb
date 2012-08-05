require 'activeadmin'

ActiveAdmin::Namespace.class_eval do
  alias_method :old_register, :register

  def register(resource_class, options = {}, &block)
    config = find_or_build_resource(resource_class, options)

    # Register the resource
    register_resource_controller(config)

    if ActiveAdmin::VERSION =~ /^0\.[5-9]/
      ActiveAdmin::ResourceDSL.new(config).prepare_menu5
    else
      resource_dsl.prepare_menu(config)
    end

    config = old_register(resource_class, options, &block)
    config.controller.load_and_authorize_resource :class => resource_class
    config
  end
end

ActiveAdmin::DSL.class_eval do
  def prepare_menu(config)
    @config = config
    resource = controller.resource_class
    instance_eval do
      menu :if => proc{ can?(:index, resource) }
    end
  end

  def prepare_menu5
    resource = controller.resource_class
    instance_eval do
      menu :if => proc{ can?(:manage, resource) }
    end
  end
end

ActiveAdmin::Views::IndexAsTable::IndexTableFor.class_eval do
  # Adds links to View, Edit and Delete
  def default_actions(options = {})
    options = {
      :name => ""
    }.merge(options)
    column options[:name] do |resource|
      links = ''.html_safe
      if controller.action_methods.include?('show') and controller.can?(:show, resource.class)
        links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      end
      if controller.action_methods.include?('edit') and controller.can?(:edit, resource.class)
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      end
      if controller.action_methods.include?('destroy') and controller.can?(:destroy, resource.class)
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      end
      links
    end
  end
end

ActiveAdmin::Resource::ActionItems.module_eval do
  private
    # Adds the default action items to each resource
    def add_default_action_items
      # New Link on all actions except :new and :show
      add_action_item :except => [:new, :show], :if => proc{ can?(:new, controller.resource_class) } do
        if controller.action_methods.include?('new')
          link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
        end
      end

      # Edit link on show
      add_action_item :only => :show, :if => proc{ can?(:edit, controller.resource_class) } do
        if controller.action_methods.include?('edit')
          link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
        end
      end

      # Destroy link on show
      add_action_item :only => :show, :if => proc{ can?(:destroy, controller.resource_class) } do
        if controller.action_methods.include?("destroy")
          link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name),
            resource_path(resource),
            :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
        end
      end
    end
end

CanCan::ControllerResource.class_eval do
  def collection_instance=(instance)
  end

  def resource_instance=(instance)
  end
end
