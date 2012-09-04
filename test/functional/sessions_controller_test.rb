require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  context "#sign_in" do
    setup do
      @user = create(:admin)
      
      @login_info = {:login => @user.email, :password => @user.password, :remember_me => 1}
    end
    
    execute do
      post :create, {:format => 'json', :user => @login_info}
    end
    
    should "return user as json" do
      assert_response :success
      
      response = JSON.parse(@execute_result.body)
      assert_equal @user.username, response["username"]
      assert_equal @user.email, response["email"]
    end
  end
  
  context "#sign_out" do
    setup do
      @user = create(:admin)
      sign_in @user
    end
    
    execute do
      delete :destroy, {:format => 'json', :user => @user}
    end
    
    should "return context with no body" do
      assert_response :success
    end
  end
end