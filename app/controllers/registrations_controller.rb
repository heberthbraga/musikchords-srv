class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, :only => [:create, :update]
  before_filter :check_permissions, :only => [:cancel]
  
  def update
    if resource.update_attributes(params[resource_name])
      respond_to do |format|
        format.html do
          set_flash_message :notice, :updated
          # Line below required if using Devise >= 1.2.0
          sign_in resource_name, resource, :bypass => true
          redirect_to after_update_path_for(resource)
        end
        format.json { render :json => resource, :status => 200 }
      end
    else
      respond_to do |format|
        format.html do
          clean_up_passwords(resource)
          render_with_scope :edit
        end
        format.json { render :json => resource.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create    
    build_resource

    resource.roles << "USER"
    
    if resource.save
      respond_to do |format|
        format.html do
          set_flash_message :notice, :signed_up
          sign_in_and_redirect(resource_name, resource)
        end
        format.json { render :json => resource, :status => 200 }
      end
    else
      format.html do
        clean_up_passwords(resource)
        render_with_scope :new
      end
      format.json { render :json => resource.errors, :status => :unprocessable_entity }
    end
  end
  
  protected
  
  def check_permissions
    authorize! :create, resource
  end
end