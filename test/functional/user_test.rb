require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context ".find_for_database_authentication" do
    setup do
      @email = 'foo@example.com'
      @username = 'foo'
      @user = create(:user, :email => @email, :username => @username)
    end
    
    execute do
      User.bypass.find_for_database_authentication @conditions
    end
    
    context "by username" do
      setup do
        @conditions = {:login => @username}
      end
      
      should "return user" do
        assert_equal @user.username, @execute_result.username
      end
    end
    
    context "by email" do
      setup do
        @conditions = {:login => @email}
      end
      
      should "return user" do
        assert_equal @user.username, @execute_result.username
      end
    end
  end
end