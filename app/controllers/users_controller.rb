class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    existing_users = User.all
    
    respond_to do |format|
      format.html { @users = pagination_for(existing_users) }
      format.json { render :json => existing_users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
  
  def edit
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
  end
  
  def update
    @user = User.find(params[:id])
    roles = {'0' => 'ADMIN', '1' => 'USER'}
    @user.roles = [roles[params[:user][:role_ids]]]
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :action => 'index' }
        format.json { render :json => @user }
      else
        format.html { redirect_to :action => 'edit' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to :action => 'index' }
        format.json { render :nothing => true }
      else
        format.html { redirect_to :action => 'edit' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def pagination_for(users)
    Kaminari.paginate_array(users).page(params[:page]).per(25)
  end
end