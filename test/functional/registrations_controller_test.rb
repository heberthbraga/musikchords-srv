require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase  
  setup do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  context "#create" do
    setup do
      @user_info = {:first_name => 'foo', :email => 'foo@example.com', :username => 'foooo', :password => '123456', :password_confirmation => '123456'}
    end
    
    execute do
      post :create, {:format => 'json', :user => @user_info} 
    end
    
    should "create a mew user" do
      assert_response :success
      assert_match /#{@user_info[:first_name]}/, @execute_result.body
      assert_match /#{@user_info[:email]}/, @execute_result.body
      assert_match /#{@user_info[:username]}/, @execute_result.body
    end
  end
  
  context "#update" do
    setup do
      @user = create(:registered)
      sign_in @user
      
      @user_info = {:first_name => 'foo bar', :email => @user.email, :username => @user.username, :password => @user.password, :password_confirmation => @user.password_confirmation}
    end
    
    teardown do
      sign_out @user
    end
    
    execute do
      put :update, {:format => 'json', :user => @user_info}
    end
    
    should "update user" do
      assert_response :success
      assert_match /#{@user_info[:first_name]}/, @execute_result.body
    end
  end
end