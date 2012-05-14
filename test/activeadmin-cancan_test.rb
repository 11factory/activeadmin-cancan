require 'test_helper'

class ActiveadminCancanTest < ActiveSupport::TestCase
  
  class Foo
  end
  
  test "authorize resource with cancan on register" do
    controller = ActiveAdmin.register(Foo).controller
    controller.expects(:load_and_authorize_resource)
    ActiveAdmin::Resource.any_instance.stubs(:controller).returns(controller)
    ActiveAdmin.register Foo
  end
  
  test "display menu only if user can manage given resource" do
    resource = ActiveAdmin.register(Foo)
    ActiveAdmin::ResourceDSL.any_instance.expects(:can?).with(:manage, Foo).returns(false)
    assert !resource.namespace.menu.items.first.display_if_block.call
    ActiveAdmin::ResourceDSL.any_instance.expects(:can?).with(:manage, Foo).returns(true)
    assert resource.namespace.menu.items.first.display_if_block.call
  end
  
end
