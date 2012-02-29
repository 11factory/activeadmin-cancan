require 'activeadmin'
 
ActiveAdmin::Namespace.class_eval do
  alias_method :old_register, :register
  
  def register(resource_class, options = {}, &block)
    config = find_or_build_resource(resource_class, options)
    register_resource_controller(config)
    resource_dsl.prepare_menu(config)
    config = old_register(resource_class, options, &block)
    config.controller.authorize_resource
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
end
