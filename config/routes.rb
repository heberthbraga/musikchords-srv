MusikchordsSrv::Application.routes.draw do
  devise_for :users, :path => 'users', :controllers => { :sessions => 'sessions', :registrations => 'registrations' }, :skip => [:sessions]
                                                                                                                
  devise_scope :user do
    # registrations
    get 'sign_up' => 'registrations#new', :as => :new_user_registration

    #sessions          
    get 'sign_in' => 'sessions#new', :as => :new_user_session
    post 'sign_in' => 'sessions#create', :as => :user_session 
    get 'sign_out' => 'sessions#destroy', :as => :destroy_user_session
  end
  
  resources :users
  
  root :to => 'index#index'
end