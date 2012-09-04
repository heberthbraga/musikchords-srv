require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin = create(:admin)
    
    sign_in @admin
  end
  
  teardown do
    sign_out @admin
  end
  
  context "#index" do
    setup do
      @users = []
      
      2.times do |i|
        @users << create(:user, :first_name => "Foo_#{i}", :email => "foo_#{i}@example.com", :username => "foo_#{i}", 
                                :password => '123456', :password_confirmation => '123456', :roles => ['USER'])
      end
    end
    
    execute do
      get :index, {:format => 'json'}
    end
    
    should "return a list of users" do
      assert_response :success
      
      response = JSON.parse(@execute_result.body)
      
      assert response.size == 3
      assert_equal @admin.username, response[0]['username']
      assert_equal @users[0].username, response[1]['username']
      assert_equal @users[1].username, response[2]['username']  
    end
  end
  
  context "#show" do
    setup do
      @user = create(:registered, :first_name => "Bar", :email => "bar@example.com", :username => "bar", 
                                  :password => '123456', :password_confirmation => '123456', :roles => ['USER'])
    end
    
    execute do
      get :show, { :format => 'json', :id => @user.id }
    end
    
    should "return a registered user" do
      assert_response :success
      
      response = JSON.parse(@execute_result.body)
      
      assert_equal @user.first_name, response['first_name']
      assert_equal @user.username, response['username']
      assert_equal @user.email, response['email']
    end
  end
  
  context "#edit" do
    setup do
      @user = create(:registered, :first_name => "John", :email => "john@example.com", :username => "john", 
                                  :password => '123456', :password_confirmation => '123456', :roles => ['USER'])
    end
    
    execute do
      get :edit, { :format => 'json', :id => @user.id }
    end
    
    should "return a registered user" do
      assert_response :success
      
      response = JSON.parse(@execute_result.body)
      
      assert_equal @user.first_name, response['first_name']
      assert_equal @user.username, response['username']
      assert_equal @user.email, response['email']
    end
  end
  
  context "#update" do          
    execute do
      put :update, { :format => 'json', :id => @user.id, :user => {:role_ids => '0'} }
    end
    
    context "success" do
      setup do
        @user = create(:registered, :first_name => "Jack", :email => "jack@example.com", :username => "john", 
                                    :password => '123456', :password_confirmation => '123456', :roles => ['USER'])
      end

      should "return a updated user" do
        assert_response :success

        response = JSON.parse(@execute_result.body)

        assert_equal @user.username, response['username']
        assert_equal 'ADMIN', response['roles'][0]
      end
    end
  end
  
  context "#destroy" do
    execute do
      delete :destroy, { :format => 'json', :id => @user.id }
    end
    
    context "success" do
      setup do
        @user = create(:registered, :first_name => "Bill", :email => "bill@example.com", :username => "bill", 
                                    :password => '123456', :password_confirmation => '123456', :roles => ['USER'])
      end

      should "user be deleted" do
        assert_response :success

        existing_user = User.find(@user.id)
        assert_nil existing_user
      end
    end
  end
end