require 'activeadmin'
 
ActiveAdmin::Namespace.class_eval do
  alias_method :old_register, :register
  
  def register(resource_class, options = {}, &block)
    config = old_register(resource_class, options, &block)
    config.controller.authorize_resource
    resource_dsl.prepare_menu(config)
    config    
  end
end

ActiveAdmin::DSL.class_eval do  
  def prepare_menu(config)
    @config = config
    instance_eval do
      resource = controller.resource_class
      menu :if => proc{ false }
    end
  end
end
