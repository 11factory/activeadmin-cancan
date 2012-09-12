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
      menu :if => proc{ can?(:manage, resource) }
    end
  end

  def prepare_menu5
    resource = controller.resource_class
    instance_eval do
      menu :if => proc{ can?(:manage, resource) }
    end
  end
end

CanCan::ControllerResource.class_eval do
  def collection_instance=(instance)
  end

  def resource_instance=(instance)
  end
end