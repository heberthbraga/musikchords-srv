require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "#password_required?" do
    execute do
      @user.password_required?
    end
    
    context "password is required" do
      setup do
        @user = build(:user, :password => 'pass1234')
      end
      
      should "return true" do
        assert @execute_result
      end
    end
    
    context "password is not required" do
      setup do
        @user = build(:user, :password => nil)
      end
      
      should "return false" do
        assert !@execute_result
      end
    end
  end
  
  context "#role?" do
    setup do
      @user = build(:user)
    end
    
    execute do
      @user.role? @role
    end
    
    context "roles" do
      setup do
        @roles = ['ADMIN', 'USER']
        @user.roles = @roles
      end
      
      context "one role" do
        setup do
          @role = 'ADMIN'
        end
        
        should "return true" do
          assert @execute_result
        end
      end
      
      context "more than one role" do
        setup do
          @role = 'USER'
        end
        
        should "return true" do
          assert @execute_result
        end
      end
    end
    
    context "unknown role" do
      setup do
        @role = 'ANY'
        @user.roles << 'USER'
      end
      
      should "return false" do
        assert !@execute_result
      end
    end
  end
end